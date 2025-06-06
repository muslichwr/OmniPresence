class ClassModel {
  final String id;
  final String className;
  final String gradeLevel;
  final String academicYear;
  final String homeroomTeacherId;
  final int studentCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional data for display
  final String? homeroomTeacherName;

  ClassModel({
    required this.id,
    required this.className,
    required this.gradeLevel,
    required this.academicYear,
    required this.homeroomTeacherId,
    required this.studentCount,
    required this.createdAt,
    required this.updatedAt,
    this.homeroomTeacherName,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['\$id'] ?? json['id'],
      className: json['class_name'],
      gradeLevel: json['grade_level'],
      academicYear: json['academic_year'],
      homeroomTeacherId: json['homeroom_teacher_id'],
      studentCount: json['student_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      homeroomTeacherName: json['homeroom_teacher_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_name': className,
      'grade_level': gradeLevel,
      'academic_year': academicYear,
      'homeroom_teacher_id': homeroomTeacherId,
      'student_count': studentCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ClassModel copyWith({
    String? className,
    String? homeroomTeacherId,
    int? studentCount,
  }) {
    return ClassModel(
      id: this.id,
      className: className ?? this.className,
      gradeLevel: this.gradeLevel,
      academicYear: this.academicYear,
      homeroomTeacherId: homeroomTeacherId ?? this.homeroomTeacherId,
      studentCount: studentCount ?? this.studentCount,
      createdAt: this.createdAt,
      updatedAt: DateTime.now(),
      homeroomTeacherName: this.homeroomTeacherName,
    );
  }
}
