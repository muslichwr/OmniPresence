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
import 'package:school_attendance/features/dashboard/presentation/widgets/active_session_card.dart';
import 'package:school_attendance/features/dashboard/presentation/widgets/announcement_card.dart';
import 'package:school_attendance/features/dashboard/presentation/widgets/class_overview_card.dart';
import 'package:school_attendance/features/dashboard/presentation/widgets/schedule_card.dart';

@RoutePage()
class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  void _loadDashboard() {
    context.read<DashboardBloc>().add(LoadTeacherDashboard());
  }

  void _handleLogout() {
    context.read<AuthBloc>().add(LogoutEvent());
  }

  void _navigateToCreateSession() {
    context.router.push(CreateSessionRoute());
  }

  void _navigateToCreateAnnouncement() {
    context.router.push(CreateAnnouncementRoute());
  }

  void _navigateToAnnouncements() {
    context.router.push(AnnouncementsRoute());
  }

  void _navigateToReports() {
    context.router.push(ReportsRoute());
  }

  void _navigateToProfile() {
    context.router.push(ProfileRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
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

          if (state is TeacherDashboardLoaded) {
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
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Create Session',
                              onPressed: _navigateToCreateSession,
                              icon: Icons.add_circle_outline,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomButton(
                              text: 'Create Announcement',
                              onPressed: _navigateToCreateAnnouncement,
                              type: ButtonType.secondary,
                              icon: Icons.announcement_outlined,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Active Sessions
                      Text(
                        'Active Sessions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 8.h),
                      if (state.activeSessions.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Text(
                              'No active sessions',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.activeSessions.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 8.h),
                          itemBuilder: (context, index) {
                            final session = state.activeSessions[index];
                            return ActiveSessionCard(session: session);
                          },
                        ),
                      SizedBox(height: 24.h),

                      // Class Overview
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Class Overview',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          TextButton(
                            onPressed: _navigateToReports,
                            child: const Text('View Reports'),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.classOverviews.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final classOverview = state.classOverviews[index];
                          return ClassOverviewCard(
                              classOverview: classOverview);
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Today's Schedule
                      Text(
                        'Today\'s Schedule',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
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

                      // Recent Announcements
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Announcements',
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
