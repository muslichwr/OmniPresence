import 'package:appwrite/appwrite.dart';
import 'package:school_attendance/config/app_constants.dart';
import 'package:school_attendance/core/services/logger_service.dart';
import 'package:school_attendance/features/dashboard/presentation/widgets/class_overview_card.dart';
import 'package:school_attendance/models/announcement_model.dart';
import 'package:school_attendance/models/attendance_record_model.dart';
import 'package:school_attendance/models/attendance_session_model.dart';
import 'package:school_attendance/models/subject_model.dart';
import 'package:school_attendance/models/user_model.dart';

class DashboardRepository {
  final Databases _databases;
  final LoggerService _logger;

  DashboardRepository(this._databases, this._logger);

  // Student Dashboard Data
  Future<StudentDashboardData> getStudentDashboardData(String studentId) async {
    try {
      // Get today's attendance
      final todayAttendance = await _getTodayAttendance(studentId);

      // Get today's schedule
      final todaySchedule = await _getTodaySchedule(studentId);

      // Get recent announcements
      final recentAnnouncements = await _getRecentAnnouncements();

      return StudentDashboardData(
        todayAttendance: todayAttendance,
        todaySchedule: todaySchedule,
        recentAnnouncements: recentAnnouncements,
      );
    } catch (e) {
      _logger.error('Failed to load student dashboard data', e);
      throw Exception('Failed to load dashboard data: $e');
    }
  }

  // Teacher Dashboard Data
  Future<TeacherDashboardData> getTeacherDashboardData(String teacherId) async {
    try {
      // Get active sessions
      final activeSessions = await _getActiveSessionsForTeacher(teacherId);

      // Get class overviews
      final classOverviews = await _getClassOverviews(teacherId);

      // Get today's schedule
      final todaySchedule = await _getTodayScheduleForTeacher(teacherId);

      // Get recent announcements
      final recentAnnouncements = await _getRecentAnnouncements();

      return TeacherDashboardData(
        activeSessions: activeSessions,
        classOverviews: classOverviews,
        todaySchedule: todaySchedule,
        recentAnnouncements: recentAnnouncements,
      );
    } catch (e) {
      _logger.error('Failed to load teacher dashboard data', e);
      throw Exception('Failed to load dashboard data: $e');
    }
  }

  // Admin Dashboard Data
  Future<AdminDashboardData> getAdminDashboardData() async {
    try {
      // Get overall statistics
      final totalStudents = await _getTotalStudents();
      final totalTeachers = await _getTotalTeachers();
      final activeSessions = await _getActiveSessionsCount();
      final todayAttendancePercentage = await _getTodayAttendancePercentage();

      // Get recent users
      final recentUsers = await _getRecentUsers();

      // Get system status
      final systemStatus = await _getSystemStatus();

      return AdminDashboardData(
        totalStudents: totalStudents,
        totalTeachers: totalTeachers,
        activeSessions: activeSessions,
        todayAttendancePercentage: todayAttendancePercentage,
        recentUsers: recentUsers,
        isDatabaseConnected: systemStatus['database'] ?? false,
        isStorageAvailable: systemStatus['storage'] ?? false,
        isAuthServiceRunning: systemStatus['auth'] ?? false,
      );
    } catch (e) {
      _logger.error('Failed to load admin dashboard data', e);
      throw Exception('Failed to load dashboard data: $e');
    }
  }

  // Private helper methods
  Future<Map<String, AttendanceStatus>?> _getTodayAttendance(
      String studentId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _databases.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.attendanceRecordsCollection,
        queries: [
          Query.equal('student_id', studentId),
          Query.greaterThanEqual('created_at', startOfDay.toIso8601String()),
          Query.lessThan('created_at', endOfDay.toIso8601String()),
        ],
      );

      if (response.documents.isEmpty) return null;

      final Map<String, AttendanceStatus> attendance = {};
      for (final doc in response.documents) {
        final record = AttendanceRecordModel.fromJson(doc.data);
        // In a real implementation, you'd get the subject name from the session
        attendance['Subject ${record.sessionId.substring(0, 8)}'] =
            record.attendanceStatus;
      }

      return attendance;
    } catch (e) {
      _logger.error('Failed to get today\'s attendance', e);
      return null;
    }
  }

  Future<List<SubjectModel>> _getTodaySchedule(String studentId) async {
    // Mock data for now - in a real implementation, you'd query the schedule
    return [
      SubjectModel(
        id: '1',
        subjectName: 'Mathematics',
        subjectCode: 'MATH101',
        teacherId: 'teacher1',
        classId: 'class1',
        scheduleDay: 'Monday',
        scheduleTimeStart: '08:00',
        scheduleTimeEnd: '09:30',
        createdAt: DateTime.now(),
        teacherName: 'Dr. Smith',
      ),
      SubjectModel(
        id: '2',
        subjectName: 'Physics',
        subjectCode: 'PHY101',
        teacherId: 'teacher2',
        classId: 'class1',
        scheduleDay: 'Monday',
        scheduleTimeStart: '10:00',
        scheduleTimeEnd: '11:30',
        createdAt: DateTime.now(),
        teacherName: 'Prof. Johnson',
      ),
    ];
  }

  Future<List<SubjectModel>> _getTodayScheduleForTeacher(
      String teacherId) async {
    // Mock data for now
    return [
      SubjectModel(
        id: '1',
        subjectName: 'Mathematics',
        subjectCode: 'MATH101',
        teacherId: teacherId,
        classId: 'class1',
        scheduleDay: 'Monday',
        scheduleTimeStart: '08:00',
        scheduleTimeEnd: '09:30',
        createdAt: DateTime.now(),
        className: 'Class 10A',
      ),
    ];
  }

  Future<List<AnnouncementModel>> _getRecentAnnouncements() async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.announcementsCollection,
        queries: [
          Query.equal('is_active', true),
          Query.orderDesc('published_at'),
          Query.limit(5),
        ],
      );

      return response.documents
          .map((doc) => AnnouncementModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      _logger.error('Failed to get recent announcements', e);
      return [];
    }
  }

  Future<List<AttendanceSessionModel>> _getActiveSessionsForTeacher(
      String teacherId) async {
    try {
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
    } catch (e) {
      _logger.error('Failed to get active sessions', e);
      return [];
    }
  }

  Future<List<ClassOverview>> _getClassOverviews(String teacherId) async {
    // Mock data for now
    return [
      ClassOverview(
        className: 'Class 10A',
        subjectName: 'Mathematics',
        presentStudents: 25,
        lateStudents: 3,
        absentStudents: 2,
        totalStudents: 30,
      ),
      ClassOverview(
        className: 'Class 10B',
        subjectName: 'Physics',
        presentStudents: 22,
        lateStudents: 1,
        absentStudents: 5,
        totalStudents: 28,
      ),
    ];
  }

  Future<int> _getTotalStudents() async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.usersCollection,
        queries: [
          Query.equal('role', AppConstants.roleStudent),
        ],
      );
      return response.total;
    } catch (e) {
      return 0;
    }
  }

  Future<int> _getTotalTeachers() async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.usersCollection,
        queries: [
          Query.equal('role', AppConstants.roleTeacher),
        ],
      );
      return response.total;
    } catch (e) {
      return 0;
    }
  }

  Future<int> _getActiveSessionsCount() async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.attendanceSessionsCollection,
        queries: [
          Query.equal('status', AppConstants.sessionStatusActive),
        ],
      );
      return response.total;
    } catch (e) {
      return 0;
    }
  }

  Future<double> _getTodayAttendancePercentage() async {
    // Mock calculation - in real implementation, calculate based on actual data
    return 85.5;
  }

  Future<List<UserModel>> _getRecentUsers() async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.usersCollection,
        queries: [
          Query.orderDesc('created_at'),
          Query.limit(10),
        ],
      );

      return response.documents
          .map((doc) => UserModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, bool>> _getSystemStatus() async {
    // Mock system status - in real implementation, check actual services
    return {
      'database': true,
      'storage': true,
      'auth': true,
    };
  }
}

// Data classes
class StudentDashboardData {
  final Map<String, AttendanceStatus>? todayAttendance;
  final List<SubjectModel> todaySchedule;
  final List<AnnouncementModel> recentAnnouncements;

  StudentDashboardData({
    this.todayAttendance,
    required this.todaySchedule,
    required this.recentAnnouncements,
  });
}

class TeacherDashboardData {
  final List<AttendanceSessionModel> activeSessions;
  final List<ClassOverview> classOverviews;
  final List<SubjectModel> todaySchedule;
  final List<AnnouncementModel> recentAnnouncements;

  TeacherDashboardData({
    required this.activeSessions,
    required this.classOverviews,
    required this.todaySchedule,
    required this.recentAnnouncements,
  });
}

class AdminDashboardData {
  final int totalStudents;
  final int totalTeachers;
  final int activeSessions;
  final double todayAttendancePercentage;
  final List<UserModel> recentUsers;
  final bool isDatabaseConnected;
  final bool isStorageAvailable;
  final bool isAuthServiceRunning;

  AdminDashboardData({
    required this.totalStudents,
    required this.totalTeachers,
    required this.activeSessions,
    required this.todayAttendancePercentage,
    required this.recentUsers,
    required this.isDatabaseConnected,
    required this.isStorageAvailable,
    required this.isAuthServiceRunning,
  });
}
