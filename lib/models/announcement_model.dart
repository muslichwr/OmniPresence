import 'package:school_attendance/config/app_constants.dart';

enum AnnouncementPriority {
  low,
  medium,
  high,
  urgent,
}

enum TargetAudience {
  all,
  students,
  teachers,
  specificClass,
}

class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final AnnouncementPriority priority;
  final TargetAudience targetAudience;
  final String? targetClassId;
  final String authorId;
  final DateTime publishedAt;
  final DateTime expiresAt;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional data for display
  final String? authorName;
  final String? targetClassName;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.targetAudience,
    this.targetClassId,
    required this.authorId,
    required this.publishedAt,
    required this.expiresAt,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.authorName,
    this.targetClassName,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['\$id'] ?? json['id'],
      title: json['title'],
      content: json['content'],
      priority: _parsePriority(json['priority']),
      targetAudience: _parseAudience(json['target_audience']),
      targetClassId: json['target_class_id'],
      authorId: json['author_id'],
      publishedAt: DateTime.parse(json['published_at']),
      expiresAt: DateTime.parse(json['expires_at']),
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      authorName: json['author_name'],
      targetClassName: json['target_class_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'priority': priority.name,
      'target_audience': targetAudience.name,
      'target_class_id': targetClassId,
      'author_id': authorId,
      'published_at': publishedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static AnnouncementPriority _parsePriority(String priority) {
    switch (priority) {
      case AppConstants.priorityLow:
        return AnnouncementPriority.low;
      case AppConstants.priorityMedium:
        return AnnouncementPriority.medium;
      case AppConstants.priorityHigh:
        return AnnouncementPriority.high;
      case AppConstants.priorityUrgent:
        return AnnouncementPriority.urgent;
      default:
        return AnnouncementPriority.medium;
    }
  }

  static TargetAudience _parseAudience(String audience) {
    switch (audience) {
      case AppConstants.audienceAll:
        return TargetAudience.all;
      case AppConstants.audienceStudents:
        return TargetAudience.students;
      case AppConstants.audienceTeachers:
        return TargetAudience.teachers;
      case AppConstants.audienceSpecificClass:
        return TargetAudience.specificClass;
      default:
        return TargetAudience.all;
    }
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isUrgent => priority == AnnouncementPriority.urgent;
  bool get isHighPriority => priority == AnnouncementPriority.high;

  AnnouncementModel copyWith({
    String? title,
    String? content,
    AnnouncementPriority? priority,
    DateTime? expiresAt,
    bool? isActive,
  }) {
    return AnnouncementModel(
      id: this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      targetAudience: this.targetAudience,
      targetClassId: this.targetClassId,
      authorId: this.authorId,
      publishedAt: this.publishedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      createdAt: this.createdAt,
      updatedAt: DateTime.now(),
      authorName: this.authorName,
      targetClassName: this.targetClassName,
    );
  }
}
