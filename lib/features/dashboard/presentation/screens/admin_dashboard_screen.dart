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
import 'package:school_attendance/features/dashboard/presentation/widgets/stats_card.dart';
import 'package:school_attendance/features/dashboard/presentation/widgets/user_list_card.dart';

@RoutePage()
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  void _loadDashboard() {
    context.read<DashboardBloc>().add(LoadAdminDashboard());
  }

  void _handleLogout() {
    context.read<AuthBloc>().add(LogoutEvent());
  }

  void _navigateToReports() {
    context.router.push(ReportsRoute());
  }

  void _navigateToSettings() {
    context.router.push(SettingsRoute());
  }

  void _navigateToProfile() {
    context.router.push(ProfileRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: _navigateToSettings,
          ),
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

          if (state is AdminDashboardLoaded) {
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
                              text: 'View Reports',
                              onPressed: _navigateToReports,
                              icon: Icons.bar_chart_outlined,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomButton(
                              text: 'Settings',
                              onPressed: _navigateToSettings,
                              type: ButtonType.secondary,
                              icon: Icons.settings_outlined,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Overall Statistics
                      Text(
                        'Overall Statistics',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 8.h),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 8.w,
                        childAspectRatio: 1.5,
                        children: [
                          StatsCard(
                            title: 'Total Students',
                            value: state.totalStudents.toString(),
                            icon: Icons.school_outlined,
                            color: AppColors.primary,
                          ),
                          StatsCard(
                            title: 'Total Teachers',
                            value: state.totalTeachers.toString(),
                            icon: Icons.person_outlined,
                            color: AppColors.secondary,
                          ),
                          StatsCard(
                            title: 'Active Sessions',
                            value: state.activeSessions.toString(),
                            icon: Icons.timer_outlined,
                            color: AppColors.accent,
                          ),
                          StatsCard(
                            title: 'Today\'s Attendance',
                            value: '${state.todayAttendancePercentage}%',
                            icon: Icons.check_circle_outline,
                            color: AppColors.success,
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Recent Users
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Users',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to user management
                            },
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.recentUsers.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final user = state.recentUsers[index];
                          return UserListCard(user: user);
                        },
                      ),
                      SizedBox(height: 24.h),

                      // System Status
                      Text(
                        'System Status',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 8.h),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            children: [
                              _buildStatusRow(
                                'Database',
                                state.isDatabaseConnected,
                                'Connected',
                                'Disconnected',
                              ),
                              SizedBox(height: 8.h),
                              _buildStatusRow(
                                'Storage',
                                state.isStorageAvailable,
                                'Available',
                                'Unavailable',
                              ),
                              SizedBox(height: 8.h),
                              _buildStatusRow(
                                'Authentication',
                                state.isAuthServiceRunning,
                                'Running',
                                'Down',
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildStatusRow(
      String title, bool isActive, String activeText, String inactiveText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.success : AppColors.error,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              isActive ? activeText : inactiveText,
              style: TextStyle(
                color: isActive ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
