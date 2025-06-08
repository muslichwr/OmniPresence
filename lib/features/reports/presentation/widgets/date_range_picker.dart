import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';

class DateRangePicker extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function(DateTime start, DateTime end) onDateRangeChanged;

  const DateRangePicker({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onDateRangeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date Range',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildDateButton(
                    context,
                    'Start Date',
                    startDate,
                    (date) => onDateRangeChanged(date, endDate),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildDateButton(
                    context,
                    'End Date',
                    endDate,
                    (date) => onDateRangeChanged(startDate, date),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton(
    BuildContext context,
    String label,
    DateTime date,
    Function(DateTime) onDateSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textMuted,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now(),
            );

            if (selectedDate != null) {
              onDateSelected(selectedDate);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16.r,
                  color: AppColors.textMuted,
                ),
                SizedBox(width: 8.w),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
