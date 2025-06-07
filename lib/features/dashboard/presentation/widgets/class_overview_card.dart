import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';

class ClassOverviewCard extends StatelessWidget {
  final ClassOverview classOverview;
  final VoidCallback? onTap;

  const ClassOverviewCard({
    Key? key,
    required this.classOverview,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final attendanceRate = classOverview.totalStudents > 0
        ? (classOverview.presentStudents / classOverview.totalStudents * 100)
        : 0.0;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    classOverview.className,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getAttendanceRateColor(attendanceRate)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${attendanceRate.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: _getAttendanceRateColor(attendanceRate),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                classOverview.subjectName,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textMuted,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatColumn('Present', classOverview.presentStudents,
                      AppColors.present),
                  _buildStatColumn(
                      'Late', classOverview.lateStudents, AppColors.late),
                  _buildStatColumn(
                      'Absent', classOverview.absentStudents, AppColors.absent),
                  _buildStatColumn(
                      'Total', classOverview.totalStudents, AppColors.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Color _getAttendanceRateColor(double rate) {
    if (rate >= 90) {
      return AppColors.success;
    } else if (rate >= 75) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }
}

// Data class for class overview
class ClassOverview {
  final String className;
  final String subjectName;
  final int presentStudents;
  final int lateStudents;
  final int absentStudents;
  final int totalStudents;

  ClassOverview({
    required this.className,
    required this.subjectName,
    required this.presentStudents,
    required this.lateStudents,
    required this.absentStudents,
    required this.totalStudents,
  });
}
