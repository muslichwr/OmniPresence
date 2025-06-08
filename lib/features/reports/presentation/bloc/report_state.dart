part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final List<AttendanceRecordModel> records;
  final AttendanceStats stats;
  final List<ChartDataPoint> chartData;
  final DateTime startDate;
  final DateTime endDate;
  final String? selectedClass;
  final String? selectedSubject;

  const ReportLoaded({
    required this.records,
    required this.stats,
    required this.chartData,
    required this.startDate,
    required this.endDate,
    this.selectedClass,
    this.selectedSubject,
  });

  @override
  List<Object?> get props => [
        records,
        stats,
        chartData,
        startDate,
        endDate,
        selectedClass,
        selectedSubject,
      ];
}

class ReportExported extends ReportState {
  final String path;

  const ReportExported({
    required this.path,
  });

  @override
  List<Object> get props => [path];
}

class ReportError extends ReportState {
  final String message;

  const ReportError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
