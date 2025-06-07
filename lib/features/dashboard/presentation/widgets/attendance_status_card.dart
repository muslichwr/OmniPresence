import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/models/attendance_record_model.dart';

class AttendanceStatusCard extends StatelessWidget {
  final Map<String, AttendanceStatus>? status;

  const AttendanceStatusCard({
    Key? key,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == null || status!.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: 48.r,
                color: AppColors.textMuted,
              ),
              SizedBox(height: 8.h),
              Text(
                'No classes today',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Enjoy your day off!',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Attendance',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            ...status!.entries
                .map((entry) => _buildStatusRow(entry.key, entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String subject, AttendanceStatus status) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              subject,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(status),
                  size: 14.r,
                  color: _getStatusColor(status),
                ),
                SizedBox(width: 4.w),
                Text(
                  status.name.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(status),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return AppColors.present;
      case AttendanceStatus.late:
        return AppColors.late;
      case AttendanceStatus.absent:
        return AppColors.absent;
    }
  }

  IconData _getStatusIcon(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.late:
        return Icons.warning;
      case AttendanceStatus.absent:
        return Icons.cancel;
    }
  }
}
