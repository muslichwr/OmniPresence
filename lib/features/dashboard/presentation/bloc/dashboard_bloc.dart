import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_attendance/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:school_attendance/features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'package:school_attendance/features/dashboard/presentation/widgets/class_overview_card.dart';
import 'package:school_attendance/models/announcement_model.dart';
import 'package:school_attendance/models/attendance_record_model.dart';
import 'package:school_attendance/models/attendance_session_model.dart';
import 'package:school_attendance/models/subject_model.dart';
import 'package:school_attendance/models/user_model.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetStudentDashboardUseCase getStudentDashboardUseCase;
  final GetTeacherDashboardUseCase getTeacherDashboardUseCase;
  final GetAdminDashboardUseCase getAdminDashboardUseCase;

  DashboardBloc({
    required this.getStudentDashboardUseCase,
    required this.getTeacherDashboardUseCase,
    required this.getAdminDashboardUseCase,
  }) : super(DashboardInitial()) {
    on<LoadStudentDashboard>(_onLoadStudentDashboard);
    on<LoadTeacherDashboard>(_onLoadTeacherDashboard);
    on<LoadAdminDashboard>(_onLoadAdminDashboard);
  }

  Future<void> _onLoadStudentDashboard(
    LoadStudentDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      final data =
          await getStudentDashboardUseCase.execute('current_student_id');

      emit(StudentDashboardLoaded(
        todayAttendance: data.todayAttendance,
        todaySchedule: data.todaySchedule,
        recentAnnouncements: data.recentAnnouncements,
      ));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<void> _onLoadTeacherDashboard(
    LoadTeacherDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      final data =
          await getTeacherDashboardUseCase.execute('current_teacher_id');

      emit(TeacherDashboardLoaded(
        activeSessions: data.activeSessions,
        classOverviews: data.classOverviews,
        todaySchedule: data.todaySchedule,
        recentAnnouncements: data.recentAnnouncements,
      ));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<void> _onLoadAdminDashboard(
    LoadAdminDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      final data = await getAdminDashboardUseCase.execute();

      emit(AdminDashboardLoaded(
        totalStudents: data.totalStudents,
        totalTeachers: data.totalTeachers,
        activeSessions: data.activeSessions,
        todayAttendancePercentage: data.todayAttendancePercentage,
        recentUsers: data.recentUsers,
        isDatabaseConnected: data.isDatabaseConnected,
        isStorageAvailable: data.isStorageAvailable,
        isAuthServiceRunning: data.isAuthServiceRunning,
      ));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }
}
