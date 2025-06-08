import 'package:appwrite/appwrite.dart';
import 'package:school_attendance/config/app_constants.dart';
import 'package:school_attendance/core/services/logger_service.dart';
import 'package:school_attendance/models/attendance_record_model.dart';

class ReportRepository {
  final Databases _databases;
  final LoggerService _logger;

  ReportRepository(this._databases, this._logger);

  Future<List<AttendanceRecordModel>> getAttendanceHistory({
    required DateTime startDate,
    required DateTime endDate,
    String? classId,
    String? subjectId,
    String? studentId,
  }) async {
    try {
      final queries = <String>[
        Query.greaterThanEqual('created_at', startDate.toIso8601String()),
        Query.lessThanEqual('created_at', endDate.toIso8601String()),
        Query.orderDesc('created_at'),
      ];

      if (classId != null) {
        // In a real implementation, you'd join with sessions to filter by class
      }

      if (subjectId != null) {
        // In a real implementation, you'd join with sessions to filter by subject
      }

      if (studentId != null) {
        queries.add(Query.equal('student_id', studentId));
      }

      final response = await _databases.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.attendanceRecordsCollection,
        queries: queries,
      );

      return response.documents
          .map((doc) => AttendanceRecordModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      _logger.error('Failed to get attendance history', e);
      throw Exception('Failed to get attendance history: $e');
    }
  }

  Future<AttendanceStats> calculateAttendanceStats({
    required DateTime startDate,
    required DateTime endDate,
    String? classId,
    String? subjectId,
    String? studentId,
  }) async {
    try {
      final records = await getAttendanceHistory(
        startDate: startDate,
        endDate: endDate,
        classId: classId,
        subjectId: subjectId,
        studentId: studentId,
      );

      final totalRecords = records.length;
      if (totalRecords == 0) {
        return AttendanceStats(
          presentPercentage: 0,
          latePercentage: 0,
          absentPercentage: 0,
          totalRecords: 0,
        );
      }

      final presentCount = records.where((r) => r.isPresent).length;
      final lateCount = records.where((r) => r.isLate).length;
      final absentCount = records.where((r) => r.isAbsent).length;

      return AttendanceStats(
        presentPercentage: (presentCount / totalRecords) * 100,
        latePercentage: (lateCount / totalRecords) * 100,
        absentPercentage: (absentCount / totalRecords) * 100,
        totalRecords: totalRecords,
      );
    } catch (e) {
      _logger.error('Failed to calculate attendance stats', e);
      throw Exception('Failed to calculate attendance stats: $e');
    }
  }

  Future<List<ChartDataPoint>> generateChartData({
    required DateTime startDate,
    required DateTime endDate,
    String? classId,
    String? subjectId,
  }) async {
    try {
      // Mock chart data for now
      final List<ChartDataPoint> chartData = [];
      final days = endDate.difference(startDate).inDays;

      for (int i = 0; i <= days; i++) {
        final date = startDate.add(Duration(days: i));
        chartData.add(ChartDataPoint(
          date: date,
          presentCount: 20 + (i % 10),
          lateCount: 2 + (i % 3),
          absentCount: 3 + (i % 2),
        ));
      }

      return chartData;
    } catch (e) {
      _logger.error('Failed to generate chart data', e);
      throw Exception('Failed to generate chart data: $e');
    }
  }

  Future<String> exportToPdf({
    required List<AttendanceRecordModel> records,
    required AttendanceStats stats,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Mock PDF export - in real implementation, use pdf package
      final fileName =
          'attendance_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '/tmp/$fileName';

      _logger.info('PDF report exported to: $filePath');
      return filePath;
    } catch (e) {
      _logger.error('Failed to export PDF', e);
      throw Exception('Failed to export PDF: $e');
    }
  }

  Future<String> exportToCsv({
    required List<AttendanceRecordModel> records,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Mock CSV export - in real implementation, use csv package
      final fileName =
          'attendance_report_${DateTime.now().millisecondsSinceEpoch}.csv';
      final filePath = '/tmp/$fileName';

      _logger.info('CSV report exported to: $filePath');
      return filePath;
    } catch (e) {
      _logger.error('Failed to export CSV', e);
      throw Exception('Failed to export CSV: $e');
    }
  }
}

// Data classes
class AttendanceStats {
  final double presentPercentage;
  final double latePercentage;
  final double absentPercentage;
  final int totalRecords;

  AttendanceStats({
    required this.presentPercentage,
    required this.latePercentage,
    required this.absentPercentage,
    required this.totalRecords,
  });
}

class ChartDataPoint {
  final DateTime date;
  final int presentCount;
  final int lateCount;
  final int absentCount;

  ChartDataPoint({
    required this.date,
    required this.presentCount,
    required this.lateCount,
    required this.absentCount,
  });
}
