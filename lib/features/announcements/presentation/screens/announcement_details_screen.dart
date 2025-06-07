import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/core/di/injection.dart';
import 'package:school_attendance/features/announcements/presentation/bloc/announcement_bloc.dart';
import 'package:school_attendance/features/common/widgets/custom_button.dart';
import 'package:school_attendance/models/announcement_model.dart';

@RoutePage()
class AnnouncementDetailsScreen extends StatefulWidget {
  final String announcementId;

  const AnnouncementDetailsScreen({
    super.key,
    required this.announcementId,
  });

  @override
  State<AnnouncementDetailsScreen> createState() =>
      _AnnouncementDetailsScreenState();
}

class _AnnouncementDetailsScreenState extends State<AnnouncementDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadAnnouncementDetails();
  }

  void _loadAnnouncementDetails() {
    context.read<AnnouncementBloc>().add(
          LoadAnnouncementDetails(announcementId: widget.announcementId),
        );
  }

  void _markAsRead() {
    context.read<AnnouncementBloc>().add(
          MarkAnnouncementAsRead(announcementId: widget.announcementId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AnnouncementBloc>(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Announcement'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  // Share functionality
                },
              ),
            ],
          ),
          body: BlocConsumer<AnnouncementBloc, AnnouncementState>(
            listener: (context, state) {
              if (state is AnnouncementError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              } else if (state is AnnouncementMarkedAsRead) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Marked as read'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AnnouncementLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is AnnouncementDetailsLoaded) {
                return _buildDetailsView(state.announcement);
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
                      'Failed to load announcement',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomButton(
                      text: 'Retry',
                      onPressed: _loadAnnouncementDetails,
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

  Widget _buildDetailsView(AnnouncementModel announcement) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Priority and Status Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(announcement.priority)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: _getPriorityColor(announcement.priority),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getPriorityIcon(announcement.priority),
                        size: 16.r,
                        color: _getPriorityColor(announcement.priority),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        announcement.priority.name.toUpperCase(),
                        style: TextStyle(
                          color: _getPriorityColor(announcement.priority),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                if (announcement.isExpired)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'EXPIRED',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 24.h),

            // Title
            Text(
              announcement.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
            ),
            SizedBox(height: 16.h),

            // Metadata
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    _buildMetadataRow(
                      'Published',
                      _formatDateTime(announcement.publishedAt),
                      Icons.calendar_today_outlined,
                    ),
                    SizedBox(height: 8.h),
                    _buildMetadataRow(
                      'Expires',
                      _formatDateTime(announcement.expiresAt),
                      Icons.schedule_outlined,
                    ),
                    SizedBox(height: 8.h),
                    _buildMetadataRow(
                      'Author',
                      announcement.authorName ?? 'Unknown',
                      Icons.person_outline,
                    ),
                    SizedBox(height: 8.h),
                    _buildMetadataRow(
                      'Audience',
                      _getAudienceText(announcement.targetAudience),
                      _getAudienceIcon(announcement.targetAudience),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Content
            Text(
              'Content',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.borderLight,
                ),
              ),
              child: Text(
                announcement.content,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textDark,
                  height: 1.6,
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Mark as Read',
                    onPressed: _markAsRead,
                    icon: Icons.check_outlined,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    text: 'Share',
                    onPressed: () {
                      // Share functionality
                    },
                    type: ButtonType.outlined,
                    icon: Icons.share_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.r,
          color: AppColors.textMuted,
        ),
        SizedBox(width: 8.w),
        Text(
          '$label:',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.low:
        return AppColors.priorityLow;
      case AnnouncementPriority.medium:
        return AppColors.priorityMedium;
      case AnnouncementPriority.high:
        return AppColors.priorityHigh;
      case AnnouncementPriority.urgent:
        return AppColors.priorityUrgent;
    }
  }

  IconData _getPriorityIcon(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.low:
        return Icons.info_outline;
      case AnnouncementPriority.medium:
        return Icons.notifications_outlined;
      case AnnouncementPriority.high:
        return Icons.priority_high_outlined;
      case AnnouncementPriority.urgent:
        return Icons.warning_outlined;
    }
  }

  IconData _getAudienceIcon(TargetAudience audience) {
    switch (audience) {
      case TargetAudience.all:
        return Icons.public;
      case TargetAudience.students:
        return Icons.school;
      case TargetAudience.teachers:
        return Icons.person;
      case TargetAudience.specificClass:
        return Icons.class_;
    }
  }

  String _getAudienceText(TargetAudience audience) {
    switch (audience) {
      case TargetAudience.all:
        return 'Everyone';
      case TargetAudience.students:
        return 'Students';
      case TargetAudience.teachers:
        return 'Teachers';
      case TargetAudience.specificClass:
        return 'Specific Class';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
