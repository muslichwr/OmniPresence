import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';
import 'package:school_attendance/config/app_constants.dart';
import 'package:school_attendance/config/routes.dart';
import 'package:school_attendance/core/services/local_storage_service.dart';
import 'package:school_attendance/core/services/logger_service.dart';
import 'package:school_attendance/features/announcements/data/repositories/announcement_repository.dart';
import 'package:school_attendance/features/announcements/domain/usecases/announcement_usecases.dart';
import 'package:school_attendance/features/announcements/presentation/bloc/announcement_bloc.dart';
import 'package:school_attendance/features/attendance/data/repositories/attendance_repository.dart';
import 'package:school_attendance/features/attendance/domain/usecases/attendance_usecases.dart';
import 'package:school_attendance/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:school_attendance/features/attendance/presentation/bloc/session_bloc.dart';
import 'package:school_attendance/features/auth/data/repositories/auth_repository.dart';
import 'package:school_attendance/features/auth/domain/usecases/auth_usecases.dart';
import 'package:school_attendance/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:school_attendance/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:school_attendance/features/dashboard/domain/usecases/dashboard_usecases.dart';
import 'package:school_attendance/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:school_attendance/features/profile/data/repositories/profile_repository.dart';
import 'package:school_attendance/features/profile/domain/usecases/profile_usecases.dart';
import 'package:school_attendance/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:school_attendance/features/reports/data/repositories/report_repository.dart';
import 'package:school_attendance/features/reports/domain/usecases/report_usecases.dart';
import 'package:school_attendance/features/reports/presentation/bloc/report_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Appwrite Client
  final client = Client()
    ..setEndpoint(AppConstants.appwriteEndpoint)
    ..setProject(AppConstants.appwriteProjectId);
  getIt.registerSingleton<Client>(client);

  // Appwrite Services
  getIt.registerSingleton<Account>(Account(client));
  getIt.registerSingleton<Databases>(Databases(client));
  getIt.registerSingleton<Realtime>(Realtime(client));

  // Core Services
  getIt.registerSingleton<LoggerService>(LoggerService());
  getIt.registerSingleton<LocalStorageService>(LocalStorageService(getIt()));

  // Router
  getIt.registerSingleton<AppRouter>(AppRouter());

  // Repositories
  getIt.registerSingleton<AuthRepository>(
      AuthRepository(getIt(), getIt(), getIt()));
  getIt.registerSingleton<AttendanceRepository>(
      AttendanceRepository(getIt(), getIt(), getIt()));
  getIt.registerSingleton<AnnouncementRepository>(
      AnnouncementRepository(getIt(), getIt()));
  getIt.registerSingleton<DashboardRepository>(
      DashboardRepository(getIt(), getIt()));
  getIt.registerSingleton<ProfileRepository>(
      ProfileRepository(getIt(), getIt()));
  getIt.registerSingleton<ReportRepository>(ReportRepository(getIt(), getIt()));

  // Use Cases
  _registerAuthUseCases();
  _registerAttendanceUseCases();
  _registerAnnouncementUseCases();
  _registerDashboardUseCases();
  _registerProfileUseCases();
  _registerReportUseCases();

  // BLoCs
  getIt.registerFactory<AuthBloc>(() => AuthBloc(
        loginUseCase: getIt(),
        logoutUseCase: getIt(),
        registerUseCase: getIt(),
        getCurrentUserUseCase: getIt(),
        resetPasswordUseCase: getIt(),
      ));

  getIt.registerFactory<AttendanceBloc>(() => AttendanceBloc(
        submitAttendanceUseCase: getIt(),
        validateSessionCodeUseCase: getIt(),
        getSessionByCodeUseCase: getIt(),
      ));

  getIt.registerFactory<SessionBloc>(() => SessionBloc(
        createSessionUseCase: getIt(),
        getActiveSessionsUseCase: getIt(),
        expireSessionUseCase: getIt(),
        getSessionAttendanceUseCase: getIt(),
        streamSessionAttendanceUseCase: getIt(),
      ));

  getIt.registerFactory<AnnouncementBloc>(() => AnnouncementBloc(
        createAnnouncementUseCase: getIt(),
        getAnnouncementsForUserUseCase: getIt(),
        markAnnouncementAsReadUseCase: getIt(),
      ));

  getIt.registerFactory<DashboardBloc>(() => DashboardBloc(
        getStudentDashboardUseCase: getIt(),
        getTeacherDashboardUseCase: getIt(),
        getAdminDashboardUseCase: getIt(),
      ));

  getIt.registerFactory<ProfileBloc>(() => ProfileBloc(
        getUserProfileUseCase: getIt(),
        updateUserProfileUseCase: getIt(),
      ));

  getIt.registerFactory<ReportBloc>(() => ReportBloc(
        generateAttendanceReportUseCase: getIt(),
        getAttendanceHistoryUseCase: getIt(),
        calculateAttendanceStatsUseCase: getIt(),
        exportReportToPdfUseCase: getIt(),
        exportReportToCsvUseCase: getIt(),
      ));
}

void _registerAuthUseCases() {
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt()));
}

void _registerAttendanceUseCases() {
  getIt.registerLazySingleton(() => CreateSessionUseCase(getIt()));
  getIt.registerLazySingleton(() => GetActiveSessionsUseCase(getIt()));
  getIt.registerLazySingleton(() => ExpireSessionUseCase(getIt()));
  getIt.registerLazySingleton(() => SubmitAttendanceUseCase(getIt()));
  getIt.registerLazySingleton(() => ValidateSessionCodeUseCase(getIt()));
  getIt.registerLazySingleton(() => GetSessionByCodeUseCase(getIt()));
  getIt.registerLazySingleton(() => GetSessionAttendanceUseCase(getIt()));
  getIt.registerLazySingleton(() => StreamSessionAttendanceUseCase(getIt()));
}

void _registerAnnouncementUseCases() {
  getIt.registerLazySingleton(() => CreateAnnouncementUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAnnouncementsForUserUseCase(getIt()));
  getIt.registerLazySingleton(() => MarkAnnouncementAsReadUseCase(getIt()));
  getIt.registerLazySingleton(() => ExpireAnnouncementUseCase(getIt()));
  getIt.registerLazySingleton(() => GetActiveAnnouncementsUseCase(getIt()));
}

void _registerDashboardUseCases() {
  getIt.registerLazySingleton(() => GetStudentDashboardUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTeacherDashboardUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAdminDashboardUseCase(getIt()));
  getIt.registerLazySingleton(() => GetTodayScheduleUseCase(getIt()));
}

void _registerProfileUseCases() {
  getIt.registerLazySingleton(() => GetUserProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateUserProfileUseCase(getIt()));
}

void _registerReportUseCases() {
  getIt.registerLazySingleton(() => GenerateAttendanceReportUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAttendanceHistoryUseCase(getIt()));
  getIt.registerLazySingleton(() => CalculateAttendanceStatsUseCase(getIt()));
  getIt.registerLazySingleton(() => ExportReportToPdfUseCase(getIt()));
  getIt.registerLazySingleton(() => ExportReportToCsvUseCase(getIt()));
}
