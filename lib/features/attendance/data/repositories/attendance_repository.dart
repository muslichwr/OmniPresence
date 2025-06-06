import 'package:appwrite/appwrite.dart';
import 'package:school_attendance/config/app_constants.dart';
import 'package:school_attendance/core/services/local_storage_service.dart';
import 'package:school_attendance/core/services/logger_service.dart';
import 'package:school_attendance/models/attendance_record_model.dart';
import 'package:school_attendance/models/attendance_session_model.dart';

class AttendanceRepository {
  final Databases _databases;
  final Realtime _realtime;
  final LocalStorageService _localStorageService;

  AttendanceRepository(
    this._databases,
    this._realtime,
    this._localStorageService,
  );

  // Session management methods
  Future<AttendanceSessionModel> createSession(
      String subjectId, int durationMinutes) async {
    final userId = _localStorageService.getUserId();
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Generate a random 6-digit code
    final sessionCode = _generateSessionCode();

    // Set expiration time
    final now = DateTime.now();
    final expiresAt = now.add(Duration(minutes: durationMinutes));

    // Create session document
    final response = await _databases.createDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.attendanceSessionsCollection,
      documentId: 'unique()',
      data: {
        'session_code': sessionCode,
        'subject_id': subjectId,
        'session_date': now.toIso8601String(),
        'session_time_start': now.toIso8601String(),
        'session_time_end': now.add(const Duration(hours: 1)).toIso8601String(),
        'code_expires_at': expiresAt.toIso8601String(),
        'status': AppConstants.sessionStatusActive,
        'created_by': userId,
        'created_at': now.toIso8601String(),
      },
    );

    return AttendanceSessionModel.fromJson(response.data);
  }

  Future<List<AttendanceSessionModel>> getActiveSessions(
      String teacherId) async {
    final response = await _databases.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.attendanceSessionsCollection,
      queries: [
        Query.equal('created_by', teacherId),
        Query.equal('status', AppConstants.sessionStatusActive),
      ],
    );

    return response.documents
        .map((doc) => AttendanceSessionModel.fromJson(doc.data))
        .toList();
  }

  Future<void> expireSession(String sessionId) async {
    await _databases.updateDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.attendanceSessionsCollection,
      documentId: sessionId,
      data: {
        'status': AppConstants.sessionStatusExpired,
      },
    );
  }

  // Attendance recording methods
  Future<AttendanceRecordModel> submitAttendance(String sessionCode) async {
    final studentId = _localStorageService.getUserId();
    if (studentId == null) {
      throw Exception('User not authenticated');
    }

    // Get session by code
    final session = await getSessionByCode(sessionCode);
    if (session == null) {
      throw Exception('Invalid session code');
    }

    // Check if session is active
    if (!session.isActive) {
      throw Exception('Session has expired');
    }

    // Check if already attended
    final hasAttended = await _hasAlreadyAttended(studentId, session.id);
    if (hasAttended) {
      throw Exception(
          'You have already marked your attendance for this session');
    }

    // Calculate attendance status
    final now = DateTime.now();
    final status = _calculateAttendanceStatus(now, session.sessionTimeStart);

    // Create attendance record
    final response = await _databases.createDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.attendanceRecordsCollection,
      documentId: 'unique()',
      data: {
        'session_id': session.id,
        'student_id': studentId,
        'attendance_status': status.name,
        'check_in_time': now.toIso8601String(),
        'location_verified': false,
        'notes': '',
        'recorded_by': studentId,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
    );

    return AttendanceRecordModel.fromJson(response.data);
  }

  Future<bool> validateSessionCode(String code) async {
    final session = await getSessionByCode(code);
    return session != null && session.isActive;
  }

  Future<AttendanceSessionModel?> getSessionByCode(String code) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.attendanceSessionsCollection,
        queries: [
          Query.equal('session_code', code),
          Query.equal('status', AppConstants.sessionStatusActive),
        ],
      );

      if (response.documents.isEmpty) {
        return null;
      }

      return AttendanceSessionModel.fromJson(response.documents.first.data);
    } catch (e) {
      return null;
    }
  }

  Future<bool> _hasAlreadyAttended(String studentId, String sessionId) async {
    final response = await _databases.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.attendanceRecordsCollection,
      queries: [
        Query.equal('student_id', studentId),
        Query.equal('session_id', sessionId),
      ],
    );

    return response.documents.isNotEmpty;
  }

  AttendanceStatus _calculateAttendanceStatus(
      DateTime submitTime, DateTime sessionStart) {
    final difference = submitTime.difference(sessionStart);

    if (difference.inMinutes <= AppConstants.lateThresholdMinutes) {
      return AttendanceStatus.present;
    } else {
      return AttendanceStatus.late;
    }
  }

  String _generateSessionCode() {
    const characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String code = '';

    for (int i = 0; i < AppConstants.sessionCodeLength; i++) {
      code +=
          characters[DateTime.now().microsecondsSinceEpoch % characters.length];
    }

    return code;
  }

  // Attendance monitoring methods
  Future<List<AttendanceRecordModel>> getSessionAttendance(
      String sessionId) async {
    final response = await _databases.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.attendanceRecordsCollection,
      queries: [
        Query.equal('session_id', sessionId),
      ],
    );

    return response.documents
        .map((doc) => AttendanceRecordModel.fromJson(doc.data))
        .toList();
  }

  Stream<List<AttendanceRecordModel>> streamSessionAttendance(
      String sessionId) {
    final subscription = _realtime.subscribe([
      'databases.${AppConstants.appwriteDatabaseId}.collections.${AppConstants.attendanceRecordsCollection}.documents'
    ]);

    return subscription.stream.map((response) {
      // Filter events for the specific session
      if (response.events
              .contains('databases.*.collections.*.documents.*.create') ||
          response.events
              .contains('databases.*.collections.*.documents.*.update')) {
        if (response.payload['session_id'] == sessionId) {
          // Fetch all records for this session
          return getSessionAttendance(sessionId);
        }
      }
      return getSessionAttendance(sessionId);
    }).asyncMap((future) => future);
  }
}
