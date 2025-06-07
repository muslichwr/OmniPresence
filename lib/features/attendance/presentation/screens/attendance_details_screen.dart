import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/core/di/injection.dart';
import 'package:school_attendance/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:school_attendance/features/common/widgets/custom_button.dart';
import 'package:school_attendance/models/attendance_record_model.dart';
import 'package:school_attendance/models/attendance_session_model.dart';

@RoutePage()
class AttendanceDetailsScreen extends StatefulWidget {
  final String sessionId;

  const AttendanceDetailsScreen({
    super.key,
    required this.sessionId,
  });

  @override
  State<AttendanceDetailsScreen> createState() =>
      _AttendanceDetailsScreenState();
}

class _AttendanceDetailsScreenState extends State<AttendanceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadAttendanceDetails();
  }

  void _loadAttendanceDetails() {
    context.read<AttendanceBloc>().add(
          LoadAttendanceDetails(sessionId: widget.sessionId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AttendanceBloc>(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Attendance Details'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadAttendanceDetails,
              ),
            ],
          ),
          body: BlocConsumer<AttendanceBloc, AttendanceState>(
            listener: (context, state) {
              if (state is AttendanceError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AttendanceLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is AttendanceDetailsLoaded) {
                return _buildDetailsView(state.session, state.records);
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.r,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Failed to load attendance details',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomButton(
                      text: 'Retry',
                      onPressed: _loadAttendanceDetails,
                      type: ButtonType.outlined,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildDetailsView(
    AttendanceSessionModel session,
    List<AttendanceRecordModel> records,
  ) {
    final presentCount = records.where((r) => r.isPresent).length;
    final lateCount = records.where((r) => r.isLate).length;
    final absentCount = records.where((r) => r.isAbsent).length;
    final totalStudents = presentCount + lateCount + absentCount;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Summary Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    _buildInfoRow('Subject', session.subjectId),
                    SizedBox(height: 8.h),
                    _buildInfoRow(
                        'Date', session.sessionDate.toString().split(' ')[0]),
                    SizedBox(height: 8.h),
                    _buildInfoRow('Time',
                        '${session.sessionTimeStart.toString().split(' ')[1].substring(0, 5)} - ${session.sessionTimeEnd.toString().split(' ')[1].substring(0, 5)}'),
                    SizedBox(height: 8.h),
                    _buildInfoRow('Session Code', session.displayCode),
                    SizedBox(height: 8.h),
                    _buildInfoRow('Status', session.status.name.toUpperCase()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Statistics Overview
            Text(
              'Attendance Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Present',
                    presentCount.toString(),
                    totalStudents > 0
                        ? (presentCount / totalStudents * 100)
                                .toStringAsFixed(1) +
                            '%'
                        : '0%',
                    AppColors.present,
                    Icons.check_circle_outline,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildStatCard(
                    'Late',
                    lateCount.toString(),
                    totalStudents > 0
                        ? (lateCount / totalStudents * 100).toStringAsFixed(1) +
                            '%'
                        : '0%',
                    AppColors.late,
                    Icons.warning_outlined,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Absent',
                    absentCount.toString(),
                    totalStudents > 0
                        ? (absentCount / totalStudents * 100)
                                .toStringAsFixed(1) +
                            '%'
                        : '0%',
                    AppColors.absent,
                    Icons.cancel_outlined,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    totalStudents.toString(),
                    '100%',
                    AppColors.primary,
                    Icons.people_outline,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Detailed Records
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Detailed Records',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                CustomButton(
                  text: 'Export',
                  onPressed: () {
                    // Export functionality
                  },
                  type: ButtonType.outlined,
                  icon: Icons.file_download_outlined,
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
                        'No attendance records found',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 16.sp,
                        ),
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
                  return _buildDetailedRecordCard(record);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 14.sp,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    String percentage,
    Color color,
    IconData icon,
  ) {
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
              count,
              style: TextStyle(
                fontSize: 20.sp,
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
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              percentage,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedRecordCard(AttendanceRecordModel record) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            CircleAvatar(
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
                size: 20.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.studentName ?? 'Unknown Student',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Check-in: ${record.checkInTime?.toString().split('.')[0] ?? 'Not recorded'}',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14.sp,
                    ),
                  ),
                  if (record.notes != null && record.notes!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      'Notes: ${record.notes}',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
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
          ],
        ),
      ),
    );
  }
}
