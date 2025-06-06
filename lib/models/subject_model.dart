class SubjectModel {
  final String id;
  final String subjectName;
  final String subjectCode;
  final String teacherId;
  final String classId;
  final String scheduleDay;
  final String scheduleTimeStart;
  final String scheduleTimeEnd;
  final DateTime createdAt;

  // Additional data for display
  final String? teacherName;
  final String? className;

  SubjectModel({
    required this.id,
    required this.subjectName,
    required this.subjectCode,
    required this.teacherId,
    required this.classId,
    required this.scheduleDay,
    required this.scheduleTimeStart,
    required this.scheduleTimeEnd,
    required this.createdAt,
    this.teacherName,
    this.className,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['\$id'] ?? json['id'],
      subjectName: json['subject_name'],
      subjectCode: json['subject_code'],
      teacherId: json['teacher_id'],
      classId: json['class_id'],
      scheduleDay: json['schedule_day'],
      scheduleTimeStart: json['schedule_time_start'],
      scheduleTimeEnd: json['schedule_time_end'],
      createdAt: DateTime.parse(json['created_at']),
      teacherName: json['teacher_name'],
      className: json['class_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_name': subjectName,
      'subject_code': subjectCode,
      'teacher_id': teacherId,
      'class_id': classId,
      'schedule_day': scheduleDay,
      'schedule_time_start': scheduleTimeStart,
      'schedule_time_end': scheduleTimeEnd,
      'created_at': createdAt.toIso8601String(),
    };
  }

  SubjectModel copyWith({
    String? subjectName,
    String? scheduleDay,
    String? scheduleTimeStart,
    String? scheduleTimeEnd,
  }) {
    return SubjectModel(
      id: this.id,
      subjectName: subjectName ?? this.subjectName,
      subjectCode: this.subjectCode,
      teacherId: this.teacherId,
      classId: this.classId,
      scheduleDay: scheduleDay ?? this.scheduleDay,
      scheduleTimeStart: scheduleTimeStart ?? this.scheduleTimeStart,
      scheduleTimeEnd: scheduleTimeEnd ?? this.scheduleTimeEnd,
      createdAt: this.createdAt,
      teacherName: this.teacherName,
      className: this.className,
    );
  }
}
