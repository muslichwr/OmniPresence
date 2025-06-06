import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/config/routes.dart';
import 'package:school_attendance/core/di/injection.dart';
import 'package:school_attendance/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:school_attendance/features/common/widgets/custom_button.dart';
import 'package:school_attendance/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:school_attendance/features/dashboard/presentation/widgets/announcement_card.dart';
import 'package:school_attendance/features/dashboard/presentation/widgets/attendance_status_card.dart';
import 'package:school_attendance/features/dashboard/presentation/widgets/schedule_card.dart';

@RoutePage()
class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  void _loadDashboard() {
    context.read<DashboardBloc>().add(LoadStudentDashboard());
  }

  void _handleLogout() {
    context.read<AuthBloc>().add(LogoutEvent());
  }

  void _navigateToAttendanceInput() {
    context.router.push(AttendanceInputRoute());
  }

  void _navigateToAnnouncements() {
    context.router.push(AnnouncementsRoute());
  }

  void _navigateToProfile() {
    context.router.push(ProfileRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: _navigateToProfile,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomButton(
                    text: 'Retry',
                    onPressed: _loadDashboard,
                    type: ButtonType.outlined,
                  ),
                ],
              ),
            );
          }

          if (state is StudentDashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async => _loadDashboard(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Actions
                      CustomButton(
                        text: 'Mark Attendance',
                        onPressed: _navigateToAttendanceInput,
                        isFullWidth: true,
                        icon: Icons.qr_code_scanner_rounded,
                      ),
                      SizedBox(height: 24.h),

                      // Today's Attendance Status
                      Text(
                        'Today\'s Attendance',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 8.h),
                      AttendanceStatusCard(
                        status: state.todayAttendance,
                      ),
                      SizedBox(height: 24.h),

                      // Schedule Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today\'s Schedule',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to full schedule
                            },
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.todaySchedule.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final subject = state.todaySchedule[index];
                          return ScheduleCard(subject: subject);
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Announcements Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Announcements',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          TextButton(
                            onPressed: _navigateToAnnouncements,
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.recentAnnouncements.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final announcement = state.recentAnnouncements[index];
                          return AnnouncementCard(announcement: announcement);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
