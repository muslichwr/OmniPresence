import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_theme.dart';
import 'package:school_attendance/config/routes.dart';
import 'package:school_attendance/core/di/injection.dart';
import 'package:school_attendance/features/auth/presentation/bloc/auth_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();

    return ScreenUtilInit(
      designSize: const Size(393, 852), // Based on Pixel 4 dimensions
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => getIt<AuthBloc>()..add(CheckAuthStatus()),
            ),
          ],
          child: MaterialApp.router(
            title: 'School Attendance',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            routerDelegate: AutoRouterDelegate(appRouter),
            routeInformationParser: appRouter.defaultRouteParser(),
          ),
        );
      },
    );
  }
}
