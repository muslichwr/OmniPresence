part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class StudentDashboardLoaded extends DashboardState {
  final Map<String, AttendanceStatus>? todayAttendance;
  final List<SubjectModel> todaySchedule;
  final List<AnnouncementModel> recentAnnouncements;

  const StudentDashboardLoaded({
    this.todayAttendance,
    required this.todaySchedule,
    required this.recentAnnouncements,
  });

  @override
  List<Object?> get props =>
      [todayAttendance, todaySchedule, recentAnnouncements];
}

class TeacherDashboardLoaded extends DashboardState {
  final List<AttendanceSessionModel> activeSessions;
  final List<ClassOverview> classOverviews;
  final List<SubjectModel> todaySchedule;
  final List<AnnouncementModel> recentAnnouncements;

  const TeacherDashboardLoaded({
    required this.activeSessions,
    required this.classOverviews,
    required this.todaySchedule,
    required this.recentAnnouncements,
  });

  @override
  List<Object> get props =>
      [activeSessions, classOverviews, todaySchedule, recentAnnouncements];
}

class AdminDashboardLoaded extends DashboardState {
  final int totalStudents;
  final int totalTeachers;
  final int activeSessions;
  final double todayAttendancePercentage;
  final List<UserModel> recentUsers;
  final bool isDatabaseConnected;
  final bool isStorageAvailable;
  final bool isAuthServiceRunning;

  const AdminDashboardLoaded({
    required this.totalStudents,
    required this.totalTeachers,
    required this.activeSessions,
    required this.todayAttendancePercentage,
    required this.recentUsers,
    required this.isDatabaseConnected,
    required this.isStorageAvailable,
    required this.isAuthServiceRunning,
  });

  @override
  List<Object> get props => [
        totalStudents,
        totalTeachers,
        activeSessions,
        todayAttendancePercentage,
        recentUsers,
        isDatabaseConnected,
        isStorageAvailable,
        isAuthServiceRunning,
      ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
