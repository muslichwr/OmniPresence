import 'package:school_attendance/config/app_constants.dart';

enum UserRole {
  student,
  teacher,
  admin,
}

class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? studentId;
  final String? classId;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.studentId,
    this.classId,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['\$id'] ?? json['id'],
      email: json['email'],
      name: json['name'],
      role: _parseRole(json['role']),
      studentId: json['student_id'],
      classId: json['class_id'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'role': role.name,
      'student_id': studentId,
      'class_id': classId,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static UserRole _parseRole(String role) {
    switch (role) {
      case AppConstants.roleStudent:
        return UserRole.student;
      case AppConstants.roleTeacher:
        return UserRole.teacher;
      case AppConstants.roleAdmin:
        return UserRole.admin;
      default:
        return UserRole.student; // Default to student if role is unknown
    }
  }

  bool get isStudent => role == UserRole.student;
  bool get isTeacher => role == UserRole.teacher;
  bool get isAdmin => role == UserRole.admin;

  UserModel copyWith({
    String? name,
    String? phone,
    String? classId,
  }) {
    return UserModel(
      id: this.id,
      email: this.email,
      name: name ?? this.name,
      role: this.role,
      studentId: this.studentId,
      classId: classId ?? this.classId,
      phone: phone ?? this.phone,
      createdAt: this.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
