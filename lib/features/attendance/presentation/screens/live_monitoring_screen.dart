import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/core/di/injection.dart';
import 'package:school_attendance/features/attendance/presentation/bloc/session_bloc.dart';
import 'package:school_attendance/features/common/widgets/custom_button.dart';
import 'package:school_attendance/models/attendance_record_model.dart';
import 'package:school_attendance/models/attendance_session_model.dart';

@RoutePage()
class LiveMonitoringScreen extends StatefulWidget {
  final String sessionId;

  const LiveMonitoringScreen({
    super.key,
    required this.sessionId,
  });

  @override
  State<LiveMonitoringScreen> createState() => _LiveMonitoringScreenState();
}

class _LiveMonitoringScreenState extends State<LiveMonitoringScreen> {
  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    context.read<SessionBloc>().add(
          StartSessionMonitoring(sessionId: widget.sessionId),
        );
  }

  void _endSession() {
    context.read<SessionBloc>().add(
          EndSession(sessionId: widget.sessionId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SessionBloc>(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Live Monitoring'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.stop_circle_outlined),
                onPressed: _endSession,
                tooltip: 'End Session',
              ),
            ],
          ),
          body: BlocConsumer<SessionBloc, SessionState>(
            listener: (context, state) {
              if (state is SessionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              } else if (state is SessionEnded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Session ended successfully'),
                    backgroundColor: AppColors.success,
                  ),
                );
                context.router.pop();
              }
            },
            builder: (context, state) {
              if (state is SessionLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is SessionMonitoring) {
                return _buildMonitoringView(
                    state.session, state.attendanceRecords);
              }

              return const Center(
                child: Text('No session data available'),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildMonitoringView(
    AttendanceSessionModel session,
    List<AttendanceRecordModel> records,
  ) {
    final presentCount = records.where((r) => r.isPresent).length;
    final lateCount = records.where((r) => r.isLate).length;
    final totalAttended = presentCount + lateCount;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Info Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Session Code',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: session.isActive
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            session.isActive ? 'ACTIVE' : 'EXPIRED',
                            style: TextStyle(
                              color: session.isActive
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.primary,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          session.displayCode,
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4.w,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (session.isActive)
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            color: AppColors.textMuted,
                            size: 16.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Expires in: ${session.timeRemaining.inMinutes} minutes',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Present',
                    presentCount.toString(),
                    AppColors.present,
                    Icons.check_circle_outline,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildStatCard(
                    'Late',
                    lateCount.toString(),
                    AppColors.late,
                    Icons.warning_outlined,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    totalAttended.toString(),
                    AppColors.primary,
                    Icons.people_outline,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Attendance List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attendance Records',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                CustomButton(
                  text: 'Refresh',
                  onPressed: _startMonitoring,
                  type: ButtonType.outlined,
                  icon: Icons.refresh,
                ),
              ],
            ),
            SizedBox(height: 16.h),

            if (records.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.h),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64.r,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No attendance records yet',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Students will appear here as they mark attendance',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: records.length,
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final record = records[index];
                  return _buildAttendanceRecordCard(record);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24.r,
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceRecordCard(AttendanceRecordModel record) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: record.isPresent
              ? AppColors.present.withOpacity(0.1)
              : record.isLate
                  ? AppColors.late.withOpacity(0.1)
                  : AppColors.absent.withOpacity(0.1),
          child: Icon(
            record.isPresent
                ? Icons.check_circle
                : record.isLate
                    ? Icons.warning
                    : Icons.cancel,
            color: record.isPresent
                ? AppColors.present
                : record.isLate
                    ? AppColors.late
                    : AppColors.absent,
          ),
        ),
        title: Text(
          record.studentName ?? 'Unknown Student',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          record.checkInTime?.toString().split('.')[0] ?? 'Not recorded',
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            color: record.isPresent
                ? AppColors.present.withOpacity(0.1)
                : record.isLate
                    ? AppColors.late.withOpacity(0.1)
                    : AppColors.absent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            record.attendanceStatus.name.toUpperCase(),
            style: TextStyle(
              color: record.isPresent
                  ? AppColors.present
                  : record.isLate
                      ? AppColors.late
                      : AppColors.absent,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }
}
