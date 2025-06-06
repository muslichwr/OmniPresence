import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/config/routes.dart';
import 'package:school_attendance/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check authentication status after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      context.read<AuthBloc>().add(CheckAuthStatus());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // Navigate based on user role
          if (state.user.isStudent) {
            context.router.replace(StudentDashboardRoute());
          } else if (state.user.isTeacher) {
            context.router.replace(TeacherDashboardRoute());
          } else {
            context.router.replace(AdminDashboardRoute());
          }
        } else if (state is Unauthenticated) {
          context.router.replace(LoginRoute());
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school_rounded,
                size: 100.r,
                color: AppColors.primary,
              ).animate().scale(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                  ),
              SizedBox(height: 24.h),
              Text(
                'School Attendance',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              )
                  .animate(delay: const Duration(milliseconds: 400))
                  .fadeIn(duration: const Duration(milliseconds: 800)),
              SizedBox(height: 8.h),
              Text(
                'Attendance made simple',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textMuted,
                    ),
              )
                  .animate(delay: const Duration(milliseconds: 600))
                  .fadeIn(duration: const Duration(milliseconds: 800)),
              SizedBox(height: 48.h),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              )
                  .animate(delay: const Duration(milliseconds: 800))
                  .fadeIn(duration: const Duration(milliseconds: 600)),
            ],
          ),
        ),
      ),
    );
  }
}
