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

// Import the generated file
part 'routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        // Splash Route (Initial)
        AutoRoute(
          page: SplashRoute.page,
          path: '/splash',
          initial: true,
        ),

        // Auth Routes
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
        ),
        AutoRoute(
          page: RegisterRoute.page,
          path: '/register',
        ),

        // Dashboard Routes - Role-specific
        AutoRoute(
          page: StudentDashboardRoute.page,
          path: '/student-dashboard',
        ),
        AutoRoute(
          page: TeacherDashboardRoute.page,
          path: '/teacher-dashboard',
        ),
        AutoRoute(
          page: AdminDashboardRoute.page,
          path: '/admin-dashboard',
        ),

        // Attendance Routes
        AutoRoute(
          page: CreateSessionRoute.page,
          path: '/create-session',
        ),
        AutoRoute(
          page: AttendanceInputRoute.page,
          path: '/attendance-input',
        ),
        AutoRoute(
          page: LiveMonitoringRoute.page,
          path: '/live-monitoring',
        ),
        AutoRoute(
          page: AttendanceDetailsRoute.page,
          path: '/attendance-details',
        ),

        // Announcement Routes
        AutoRoute(
          page: AnnouncementsRoute.page,
          path: '/announcements',
        ),
        AutoRoute(
          page: AnnouncementDetailsRoute.page,
          path: '/announcement-details',
        ),
        AutoRoute(
          page: CreateAnnouncementRoute.page,
          path: '/create-announcement',
        ),

        // Profile Route
        AutoRoute(
          page: ProfileRoute.page,
          path: '/profile',
        ),

        // Reports Route
        AutoRoute(
          page: ReportsRoute.page,
          path: '/reports',
        ),

        // Settings Route
        AutoRoute(
          page: SettingsRoute.page,
          path: '/settings',
        ),
      ];
}
