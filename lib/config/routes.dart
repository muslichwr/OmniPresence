import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:school_attendance/features/announcements/presentation/screens/announcement_details_screen.dart';
import 'package:school_attendance/features/announcements/presentation/screens/announcements_screen.dart';
import 'package:school_attendance/features/announcements/presentation/screens/create_announcement_screen.dart';
import 'package:school_attendance/features/attendance/presentation/screens/attendance_details_screen.dart';
import 'package:school_attendance/features/attendance/presentation/screens/attendance_input_screen.dart';
import 'package:school_attendance/features/attendance/presentation/screens/create_session_screen.dart';
import 'package:school_attendance/features/attendance/presentation/screens/live_monitoring_screen.dart';
import 'package:school_attendance/features/auth/presentation/screens/login_screen.dart';
import 'package:school_attendance/features/auth/presentation/screens/register_screen.dart';
import 'package:school_attendance/features/dashboard/presentation/screens/admin_dashboard_screen.dart';
import 'package:school_attendance/features/dashboard/presentation/screens/student_dashboard_screen.dart';
import 'package:school_attendance/features/dashboard/presentation/screens/teacher_dashboard_screen.dart';
import 'package:school_attendance/features/profile/presentation/screens/profile_screen.dart';
import 'package:school_attendance/features/reports/presentation/screens/reports_screen.dart';
import 'package:school_attendance/features/settings/presentation/screens/settings_screen.dart';
import 'package:school_attendance/features/splash/presentation/screens/splash_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashScreen, initial: true),
    AutoRoute(page: LoginScreen),
    AutoRoute(page: RegisterScreen),

    // Dashboard Routes - Role-specific
    AutoRoute(page: StudentDashboardScreen),
    AutoRoute(page: TeacherDashboardScreen),
    AutoRoute(page: AdminDashboardScreen),

    // Attendance Routes
    AutoRoute(page: CreateSessionScreen),
    AutoRoute(page: AttendanceInputScreen),
    AutoRoute(page: LiveMonitoringScreen),
    AutoRoute(page: AttendanceDetailsScreen),

    // Announcement Routes
    AutoRoute(page: AnnouncementsScreen),
    AutoRoute(page: AnnouncementDetailsScreen),
    AutoRoute(page: CreateAnnouncementScreen),

    // Profile Route
    AutoRoute(page: ProfileScreen),

    // Reports Route
    AutoRoute(page: ReportsScreen),

    // Settings Route
    AutoRoute(page: SettingsScreen),
  ],
)
class $AppRouter {}
