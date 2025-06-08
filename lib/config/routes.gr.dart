// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'routes.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AdminDashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AdminDashboardScreen(),
      );
    },
    AnnouncementDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<AnnouncementDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AnnouncementDetailsScreen(
          key: args.key,
          announcementId: args.announcementId,
        ),
      );
    },
    AnnouncementsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AnnouncementsScreen(),
      );
    },
    AttendanceDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<AttendanceDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AttendanceDetailsScreen(
          key: args.key,
          sessionId: args.sessionId,
        ),
      );
    },
    AttendanceInputRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AttendanceInputScreen(),
      );
    },
    CreateAnnouncementRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CreateAnnouncementScreen(),
      );
    },
    CreateSessionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CreateSessionScreen(),
      );
    },
    LiveMonitoringRoute.name: (routeData) {
      final args = routeData.argsAs<LiveMonitoringRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LiveMonitoringScreen(
          key: args.key,
          sessionId: args.sessionId,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileScreen(),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterScreen(),
      );
    },
    ReportsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ReportsScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    StudentDashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StudentDashboardScreen(),
      );
    },
    TeacherDashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TeacherDashboardScreen(),
      );
    },
  };
}

/// generated route for
/// [AdminDashboardScreen]
class AdminDashboardRoute extends PageRouteInfo<void> {
  const AdminDashboardRoute({List<PageRouteInfo>? children})
      : super(
          AdminDashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdminDashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AnnouncementDetailsScreen]
class AnnouncementDetailsRoute
    extends PageRouteInfo<AnnouncementDetailsRouteArgs> {
  AnnouncementDetailsRoute({
    Key? key,
    required String announcementId,
    List<PageRouteInfo>? children,
  }) : super(
          AnnouncementDetailsRoute.name,
          args: AnnouncementDetailsRouteArgs(
            key: key,
            announcementId: announcementId,
          ),
          initialChildren: children,
        );

  static const String name = 'AnnouncementDetailsRoute';

  static const PageInfo<AnnouncementDetailsRouteArgs> page =
      PageInfo<AnnouncementDetailsRouteArgs>(name);
}

class AnnouncementDetailsRouteArgs {
  const AnnouncementDetailsRouteArgs({
    this.key,
    required this.announcementId,
  });

  final Key? key;

  final String announcementId;

  @override
  String toString() {
    return 'AnnouncementDetailsRouteArgs{key: $key, announcementId: $announcementId}';
  }
}

/// generated route for
/// [AnnouncementsScreen]
class AnnouncementsRoute extends PageRouteInfo<void> {
  const AnnouncementsRoute({List<PageRouteInfo>? children})
      : super(
          AnnouncementsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AnnouncementsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AttendanceDetailsScreen]
class AttendanceDetailsRoute extends PageRouteInfo<AttendanceDetailsRouteArgs> {
  AttendanceDetailsRoute({
    Key? key,
    required String sessionId,
    List<PageRouteInfo>? children,
  }) : super(
          AttendanceDetailsRoute.name,
          args: AttendanceDetailsRouteArgs(
            key: key,
            sessionId: sessionId,
          ),
          initialChildren: children,
        );

  static const String name = 'AttendanceDetailsRoute';

  static const PageInfo<AttendanceDetailsRouteArgs> page =
      PageInfo<AttendanceDetailsRouteArgs>(name);
}

class AttendanceDetailsRouteArgs {
  const AttendanceDetailsRouteArgs({
    this.key,
    required this.sessionId,
  });

  final Key? key;

  final String sessionId;

  @override
  String toString() {
    return 'AttendanceDetailsRouteArgs{key: $key, sessionId: $sessionId}';
  }
}

/// generated route for
/// [AttendanceInputScreen]
class AttendanceInputRoute extends PageRouteInfo<void> {
  const AttendanceInputRoute({List<PageRouteInfo>? children})
      : super(
          AttendanceInputRoute.name,
          initialChildren: children,
        );

  static const String name = 'AttendanceInputRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CreateAnnouncementScreen]
class CreateAnnouncementRoute extends PageRouteInfo<void> {
  const CreateAnnouncementRoute({List<PageRouteInfo>? children})
      : super(
          CreateAnnouncementRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateAnnouncementRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CreateSessionScreen]
class CreateSessionRoute extends PageRouteInfo<void> {
  const CreateSessionRoute({List<PageRouteInfo>? children})
      : super(
          CreateSessionRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateSessionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LiveMonitoringScreen]
class LiveMonitoringRoute extends PageRouteInfo<LiveMonitoringRouteArgs> {
  LiveMonitoringRoute({
    Key? key,
    required String sessionId,
    List<PageRouteInfo>? children,
  }) : super(
          LiveMonitoringRoute.name,
          args: LiveMonitoringRouteArgs(
            key: key,
            sessionId: sessionId,
          ),
          initialChildren: children,
        );

  static const String name = 'LiveMonitoringRoute';

  static const PageInfo<LiveMonitoringRouteArgs> page =
      PageInfo<LiveMonitoringRouteArgs>(name);
}

class LiveMonitoringRouteArgs {
  const LiveMonitoringRouteArgs({
    this.key,
    required this.sessionId,
  });

  final Key? key;

  final String sessionId;

  @override
  String toString() {
    return 'LiveMonitoringRouteArgs{key: $key, sessionId: $sessionId}';
  }
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ReportsScreen]
class ReportsRoute extends PageRouteInfo<void> {
  const ReportsRoute({List<PageRouteInfo>? children})
      : super(
          ReportsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReportsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StudentDashboardScreen]
class StudentDashboardRoute extends PageRouteInfo<void> {
  const StudentDashboardRoute({List<PageRouteInfo>? children})
      : super(
          StudentDashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'StudentDashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TeacherDashboardScreen]
class TeacherDashboardRoute extends PageRouteInfo<void> {
  const TeacherDashboardRoute({List<PageRouteInfo>? children})
      : super(
          TeacherDashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'TeacherDashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
