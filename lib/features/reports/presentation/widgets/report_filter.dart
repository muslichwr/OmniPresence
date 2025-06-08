import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';

class ReportFilter extends StatelessWidget {
  final String? selectedClass;
  final String? selectedSubject;
  final Function(String?) onClassChanged;
  final Function(String?) onSubjectChanged;

  const ReportFilter({
    Key? key,
    this.selectedClass,
    this.selectedSubject,
    required this.onClassChanged,
    required this.onSubjectChanged,
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
              'Filters',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    'Class',
                    selectedClass,
                    ['All Classes', 'Class 10A', 'Class 10B', 'Class 11A'],
                    onClassChanged,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildDropdown(
                    'Subject',
                    selectedSubject,
                    ['All Subjects', 'Mathematics', 'Physics', 'Chemistry'],
                    onSubjectChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderLight),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text('Select $label'),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item == 'All ${label}s' ? null : item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
