import 'package:school_attendance/features/reports/data/repositories/report_repository.dart';
import 'package:school_attendance/models/attendance_record_model.dart';

class GenerateAttendanceReportUseCase {
  final ReportRepository repository;

  GenerateAttendanceReportUseCase(this.repository);

  Future<AttendanceReportData> execute({
    required DateTime startDate,
    required DateTime endDate,
    String? classId,
    String? subjectId,
    String? studentId,
  }) async {
    final records = await repository.getAttendanceHistory(
      startDate: startDate,
      endDate: endDate,
      classId: classId,
      subjectId: subjectId,
      studentId: studentId,
    );

    final stats = await repository.calculateAttendanceStats(
      startDate: startDate,
      endDate: endDate,
      classId: classId,
      subjectId: subjectId,
      studentId: studentId,
    );

    final chartData = await repository.generateChartData(
      startDate: startDate,
      endDate: endDate,
      classId: classId,
      subjectId: subjectId,
    );

    return AttendanceReportData(
      records: records,
      stats: stats,
      chartData: chartData,
      startDate: startDate,
      endDate: endDate,
      selectedClass: classId,
      selectedSubject: subjectId,
    );
  }
}

class GetAttendanceHistoryUseCase {
  final ReportRepository repository;

  GetAttendanceHistoryUseCase(this.repository);

  Future<List<AttendanceRecordModel>> execute({
    required DateTime startDate,
    required DateTime endDate,
    String? classId,
    String? subjectId,
    String? studentId,
  }) {
    return repository.getAttendanceHistory(
      startDate: startDate,
      endDate: endDate,
      classId: classId,
      subjectId: subjectId,
      studentId: studentId,
    );
  }
}

class CalculateAttendanceStatsUseCase {
  final ReportRepository repository;

  CalculateAttendanceStatsUseCase(this.repository);

  Future<AttendanceStats> execute({
    required DateTime startDate,
    required DateTime endDate,
    String? classId,
    String? subjectId,
    String? studentId,
  }) {
    return repository.calculateAttendanceStats(
      startDate: startDate,
      endDate: endDate,
      classId: classId,
      subjectId: subjectId,
      studentId: studentId,
    );
  }
}

class ExportReportToPdfUseCase {
  final ReportRepository repository;

  ExportReportToPdfUseCase(this.repository);

  Future<String> execute({
    required List<AttendanceRecordModel> records,
    required AttendanceStats stats,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return repository.exportToPdf(
      records: records,
      stats: stats,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

class ExportReportToCsvUseCase {
  final ReportRepository repository;

  ExportReportToCsvUseCase(this.repository);

  Future<String> execute({
    required List<AttendanceRecordModel> records,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return repository.exportToCsv(
      records: records,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

// Data classes
class AttendanceReportData {
  final List<AttendanceRecordModel> records;
  final AttendanceStats stats;
  final List<ChartDataPoint> chartData;
  final DateTime startDate;
  final DateTime endDate;
  final String? selectedClass;
  final String? selectedSubject;

  AttendanceReportData({
    required this.records,
    required this.stats,
    required this.chartData,
    required this.startDate,
    required this.endDate,
    this.selectedClass,
    this.selectedSubject,
  });
}
