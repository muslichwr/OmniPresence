import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_attendance/features/reports/data/repositories/report_repository.dart';
import 'package:school_attendance/features/reports/domain/usecases/report_usecases.dart';
import 'package:school_attendance/models/attendance_record_model.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GenerateAttendanceReportUseCase generateAttendanceReportUseCase;
  final GetAttendanceHistoryUseCase getAttendanceHistoryUseCase;
  final CalculateAttendanceStatsUseCase calculateAttendanceStatsUseCase;
  final ExportReportToPdfUseCase exportReportToPdfUseCase;
  final ExportReportToCsvUseCase exportReportToCsvUseCase;

  ReportBloc({
    required this.generateAttendanceReportUseCase,
    required this.getAttendanceHistoryUseCase,
    required this.calculateAttendanceStatsUseCase,
    required this.exportReportToPdfUseCase,
    required this.exportReportToCsvUseCase,
  }) : super(ReportInitial()) {
    on<LoadAttendanceReport>(_onLoadAttendanceReport);
    on<UpdateDateRange>(_onUpdateDateRange);
    on<UpdateReportFilter>(_onUpdateReportFilter);
    on<ExportReportToPdf>(_onExportReportToPdf);
    on<ExportReportToCsv>(_onExportReportToCsv);
  }

  Future<void> _onLoadAttendanceReport(
    LoadAttendanceReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());

    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 30));

      final reportData = await generateAttendanceReportUseCase.execute(
        startDate: startDate,
        endDate: endDate,
      );

      emit(ReportLoaded(
        records: reportData.records,
        stats: reportData.stats,
        chartData: reportData.chartData,
        startDate: reportData.startDate,
        endDate: reportData.endDate,
        selectedClass: reportData.selectedClass,
        selectedSubject: reportData.selectedSubject,
      ));
    } catch (e) {
      emit(ReportError(message: e.toString()));
    }
  }

  Future<void> _onUpdateDateRange(
    UpdateDateRange event,
    Emitter<ReportState> emit,
  ) async {
    if (state is ReportLoaded) {
      final currentState = state as ReportLoaded;
      emit(ReportLoading());

      try {
        final reportData = await generateAttendanceReportUseCase.execute(
          startDate: event.start,
          endDate: event.end,
          classId: currentState.selectedClass,
          subjectId: currentState.selectedSubject,
        );

        emit(ReportLoaded(
          records: reportData.records,
          stats: reportData.stats,
          chartData: reportData.chartData,
          startDate: reportData.startDate,
          endDate: reportData.endDate,
          selectedClass: reportData.selectedClass,
          selectedSubject: reportData.selectedSubject,
        ));
      } catch (e) {
        emit(ReportError(message: e.toString()));
      }
    }
  }

  Future<void> _onUpdateReportFilter(
    UpdateReportFilter event,
    Emitter<ReportState> emit,
  ) async {
    if (state is ReportLoaded) {
      final currentState = state as ReportLoaded;
      emit(ReportLoading());

      try {
        final reportData = await generateAttendanceReportUseCase.execute(
          startDate: currentState.startDate,
          endDate: currentState.endDate,
          classId: event.classId ?? currentState.selectedClass,
          subjectId: event.subjectId ?? currentState.selectedSubject,
        );

        emit(ReportLoaded(
          records: reportData.records,
          stats: reportData.stats,
          chartData: reportData.chartData,
          startDate: reportData.startDate,
          endDate: reportData.endDate,
          selectedClass: event.classId ?? currentState.selectedClass,
          selectedSubject: event.subjectId ?? currentState.selectedSubject,
        ));
      } catch (e) {
        emit(ReportError(message: e.toString()));
      }
    }
  }

  Future<void> _onExportReportToPdf(
    ExportReportToPdf event,
    Emitter<ReportState> emit,
  ) async {
    if (state is ReportLoaded) {
      final currentState = state as ReportLoaded;

      try {
        final filePath = await exportReportToPdfUseCase.execute(
          records: currentState.records,
          stats: currentState.stats,
          startDate: currentState.startDate,
          endDate: currentState.endDate,
        );

        emit(ReportExported(path: filePath));
        emit(currentState); // Return to previous state
      } catch (e) {
        emit(ReportError(message: e.toString()));
      }
    }
  }

  Future<void> _onExportReportToCsv(
    ExportReportToCsv event,
    Emitter<ReportState> emit,
  ) async {
    if (state is ReportLoaded) {
      final currentState = state as ReportLoaded;

      try {
        final filePath = await exportReportToCsvUseCase.execute(
          records: currentState.records,
          startDate: currentState.startDate,
          endDate: currentState.endDate,
        );

        emit(ReportExported(path: filePath));
        emit(currentState); // Return to previous state
      } catch (e) {
        emit(ReportError(message: e.toString()));
      }
    }
  }
}
