import 'package:school_attendance/config/app_constants.dart';

enum SessionStatus {
  active,
  expired,
  completed,
}

class AttendanceSessionModel {
  final String id;
  final String sessionCode;
  final String subjectId;
  final DateTime sessionDate;
  final DateTime sessionTimeStart;
  final DateTime sessionTimeEnd;
  final DateTime codeExpiresAt;
  final SessionStatus status;
  final String createdBy;
  final DateTime createdAt;

  AttendanceSessionModel({
    required this.id,
    required this.sessionCode,
    required this.subjectId,
    required this.sessionDate,
    required this.sessionTimeStart,
    required this.sessionTimeEnd,
    required this.codeExpiresAt,
    required this.status,
    required this.createdBy,
    required this.createdAt,
  });

  factory AttendanceSessionModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSessionModel(
      id: json['\$id'] ?? json['id'],
      sessionCode: json['session_code'],
      subjectId: json['subject_id'],
      sessionDate: DateTime.parse(json['session_date']),
      sessionTimeStart: DateTime.parse(json['session_time_start']),
      sessionTimeEnd: DateTime.parse(json['session_time_end']),
      codeExpiresAt: DateTime.parse(json['code_expires_at']),
      status: _parseStatus(json['status']),
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_code': sessionCode,
      'subject_id': subjectId,
      'session_date': sessionDate.toIso8601String(),
      'session_time_start': sessionTimeStart.toIso8601String(),
      'session_time_end': sessionTimeEnd.toIso8601String(),
      'code_expires_at': codeExpiresAt.toIso8601String(),
      'status': status.name,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static SessionStatus _parseStatus(String status) {
    switch (status) {
      case AppConstants.sessionStatusActive:
        return SessionStatus.active;
      case AppConstants.sessionStatusExpired:
        return SessionStatus.expired;
      case AppConstants.sessionStatusCompleted:
        return SessionStatus.completed;
      default:
        return SessionStatus.expired;
    }
  }

  bool get isActive =>
      status == SessionStatus.active && DateTime.now().isBefore(codeExpiresAt);
  bool get isExpired => DateTime.now().isAfter(codeExpiresAt);
  String get displayCode =>
      '${sessionCode.substring(0, 3)}-${sessionCode.substring(3)}';
  Duration get timeRemaining => codeExpiresAt.difference(DateTime.now());

  AttendanceSessionModel copyWith({
    SessionStatus? status,
    DateTime? codeExpiresAt,
  }) {
    return AttendanceSessionModel(
      id: this.id,
      sessionCode: this.sessionCode,
      subjectId: this.subjectId,
      sessionDate: this.sessionDate,
      sessionTimeStart: this.sessionTimeStart,
      sessionTimeEnd: this.sessionTimeEnd,
      codeExpiresAt: codeExpiresAt ?? this.codeExpiresAt,
      status: status ?? this.status,
      createdBy: this.createdBy,
      createdAt: this.createdAt,
    );
  }
}
