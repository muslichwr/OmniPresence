part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadAttendanceReport extends ReportEvent {}

class UpdateDateRange extends ReportEvent {
  final DateTime start;
  final DateTime end;

  const UpdateDateRange({
    required this.start,
    required this.end,
  });

  @override
  List<Object> get props => [start, end];
}

class UpdateReportFilter extends ReportEvent {
  final String? classId;
  final String? subjectId;

  const UpdateReportFilter({
    this.classId,
    this.subjectId,
  });

  @override
  List<Object?> get props => [classId, subjectId];
}

class ExportReportToPdf extends ReportEvent {}

class ExportReportToCsv extends ReportEvent {}
