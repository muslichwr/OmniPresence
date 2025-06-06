import 'package:school_attendance/config/app_constants.dart';

enum AttendanceStatus {
  present,
  late,
  absent,
}

class AttendanceRecordModel {
  final String id;
  final String sessionId;
  final String studentId;
  final AttendanceStatus attendanceStatus;
  final DateTime? checkInTime;
  final bool locationVerified;
  final String? notes;
  final String recordedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional student info (for display purposes)
  final String? studentName;
  final String? studentClass;

  AttendanceRecordModel({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.attendanceStatus,
    this.checkInTime,
    this.locationVerified = false,
    this.notes,
    required this.recordedBy,
    required this.createdAt,
    required this.updatedAt,
    this.studentName,
    this.studentClass,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['\$id'] ?? json['id'],
      sessionId: json['session_id'],
      studentId: json['student_id'],
      attendanceStatus: _parseStatus(json['attendance_status']),
      checkInTime: json['check_in_time'] != null
          ? DateTime.parse(json['check_in_time'])
          : null,
      locationVerified: json['location_verified'] ?? false,
      notes: json['notes'],
      recordedBy: json['recorded_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      studentName: json['student_name'],
      studentClass: json['student_class'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'student_id': studentId,
      'attendance_status': attendanceStatus.name,
      'check_in_time': checkInTime?.toIso8601String(),
      'location_verified': locationVerified,
      'notes': notes,
      'recorded_by': recordedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static AttendanceStatus _parseStatus(String status) {
    switch (status) {
      case AppConstants.statusPresent:
        return AttendanceStatus.present;
      case AppConstants.statusLate:
        return AttendanceStatus.late;
      case AppConstants.statusAbsent:
        return AttendanceStatus.absent;
      default:
        return AttendanceStatus.absent;
    }
  }

  // Helper methods
  bool get isPresent => attendanceStatus == AttendanceStatus.present;
  bool get isLate => attendanceStatus == AttendanceStatus.late;
  bool get isAbsent => attendanceStatus == AttendanceStatus.absent;

  AttendanceRecordModel copyWith({
    AttendanceStatus? attendanceStatus,
    DateTime? checkInTime,
    bool? locationVerified,
    String? notes,
  }) {
    return AttendanceRecordModel(
      id: this.id,
      sessionId: this.sessionId,
      studentId: this.studentId,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      checkInTime: checkInTime ?? this.checkInTime,
      locationVerified: locationVerified ?? this.locationVerified,
      notes: notes ?? this.notes,
      recordedBy: this.recordedBy,
      createdAt: this.createdAt,
      updatedAt: DateTime.now(),
      studentName: this.studentName,
      studentClass: this.studentClass,
    );
  }
}
