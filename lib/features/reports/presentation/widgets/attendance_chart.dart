import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/features/reports/data/repositories/report_repository.dart';

class AttendanceChart extends StatelessWidget {
  final List<ChartDataPoint> data;

  const AttendanceChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 16.sp,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Chart Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLegendItem('Present', AppColors.present),
            _buildLegendItem('Late', AppColors.late),
            _buildLegendItem('Absent', AppColors.absent),
          ],
        ),
        SizedBox(height: 16.h),

        // Simple Bar Chart (mock implementation)
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: data.take(7).map((point) => _buildBar(point)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 4.w),
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

  Widget _buildBar(ChartDataPoint point) {
    final total = point.presentCount + point.lateCount + point.absentCount;
    final maxHeight = 120.h;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${point.date.day}',
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textMuted,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 20.w,
          height: total > 0 ? (total / 30 * maxHeight) : 10.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.r),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppColors.present,
                AppColors.late,
                AppColors.absent,
              ],
              stops: total > 0
                  ? [
                      point.presentCount / total,
                      (point.presentCount + point.lateCount) / total,
                      1.0,
                    ]
                  : [0.33, 0.66, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}
