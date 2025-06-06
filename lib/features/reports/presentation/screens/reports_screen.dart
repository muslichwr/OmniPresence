import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/core/di/injection.dart';
import 'package:school_attendance/features/common/widgets/custom_button.dart';
import 'package:school_attendance/features/reports/presentation/bloc/report_bloc.dart';
import 'package:school_attendance/features/reports/presentation/widgets/attendance_chart.dart';
import 'package:school_attendance/features/reports/presentation/widgets/date_range_picker.dart';
import 'package:school_attendance/features/reports/presentation/widgets/report_filter.dart';

@RoutePage()
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    context.read<ReportBloc>().add(LoadAttendanceReport());
  }

  void _exportToPdf() {
    context.read<ReportBloc>().add(ExportReportToPdf());
  }

  void _exportToCsv() {
    context.read<ReportBloc>().add(ExportReportToCsv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: _exportToPdf,
            tooltip: 'Export to PDF',
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: _exportToCsv,
            tooltip: 'Export to CSV',
          ),
        ],
      ),
      body: BlocConsumer<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is ReportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is ReportExported) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Report exported successfully to ${state.path}'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ReportLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Range Picker
                    DateRangePicker(
                      startDate: state.startDate,
                      endDate: state.endDate,
                      onDateRangeChanged: (start, end) {
                        context.read<ReportBloc>().add(
                              UpdateDateRange(start: start, end: end),
                            );
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Filters
                    ReportFilter(
                      selectedClass: state.selectedClass,
                      selectedSubject: state.selectedSubject,
                      onClassChanged: (classId) {
                        context.read<ReportBloc>().add(
                              UpdateReportFilter(classId: classId),
                            );
                      },
                      onSubjectChanged: (subjectId) {
                        context.read<ReportBloc>().add(
                              UpdateReportFilter(subjectId: subjectId),
                            );
                      },
                    ),
                    SizedBox(height: 24.h),

                    // Overall Statistics
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Overall Statistics',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  'Present',
                                  state.stats.presentPercentage,
                                  AppColors.present,
                                ),
                                _buildStatItem(
                                  'Late',
                                  state.stats.latePercentage,
                                  AppColors.late,
                                ),
                                _buildStatItem(
                                  'Absent',
                                  state.stats.absentPercentage,
                                  AppColors.absent,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Attendance Chart
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Attendance Trends',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: 16.h),
                            SizedBox(
                              height: 200.h,
                              child: AttendanceChart(data: state.chartData),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Detailed Records
                    Text(
                      'Detailed Records',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.records.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        final record = state.records[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(
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
                            title:
                                Text(record.studentName ?? 'Unknown Student'),
                            subtitle: Text(
                              '${record.checkInTime?.toString().split('.')[0] ?? 'Not recorded'}',
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
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatItem(String label, double percentage, Color color) {
    return Column(
      children: [
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
