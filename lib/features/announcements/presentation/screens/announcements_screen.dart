import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/config/routes.dart';
import 'package:school_attendance/core/di/injection.dart';
import 'package:school_attendance/features/announcements/presentation/bloc/announcement_bloc.dart';
import 'package:school_attendance/features/common/widgets/custom_button.dart';
import 'package:school_attendance/models/announcement_model.dart';

@RoutePage()
class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  void _loadAnnouncements() {
    context.read<AnnouncementBloc>().add(LoadAnnouncements());
  }

  void _navigateToCreateAnnouncement() {
    context.router.push(CreateAnnouncementRoute());
  }

  void _navigateToAnnouncementDetails(AnnouncementModel announcement) {
    context.router
        .push(AnnouncementDetailsRoute(announcementId: announcement.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AnnouncementBloc>(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Announcements'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _navigateToCreateAnnouncement,
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
              }
            },
            builder: (context, state) {
              if (state is AnnouncementLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is AnnouncementsLoaded) {
                return RefreshIndicator(
                  onRefresh: () async => _loadAnnouncements(),
                  child: _buildAnnouncementsList(state.announcements),
                );
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.announcement_outlined,
                      size: 64.r,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Failed to load announcements',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomButton(
                      text: 'Retry',
                      onPressed: _loadAnnouncements,
                      type: ButtonType.outlined,
                    ),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _navigateToCreateAnnouncement,
            child: const Icon(Icons.add),
          ),
        );
      }),
    );
  }

  Widget _buildAnnouncementsList(List<AnnouncementModel> announcements) {
    if (announcements.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.announcement_outlined,
                size: 64.r,
                color: AppColors.textMuted,
              ),
              SizedBox(height: 16.h),
              Text(
                'No announcements yet',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Check back later for updates from your school',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              CustomButton(
                text: 'Create Announcement',
                onPressed: _navigateToCreateAnnouncement,
                icon: Icons.add,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: announcements.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        return _buildAnnouncementCard(announcement);
      },
    );
  }

  Widget _buildAnnouncementCard(AnnouncementModel announcement) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _navigateToAnnouncementDetails(announcement),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with priority and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(announcement.priority)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      announcement.priority.name.toUpperCase(),
                      style: TextStyle(
                        color: _getPriorityColor(announcement.priority),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  Text(
                    _formatDate(announcement.publishedAt),
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Title
              Text(
                announcement.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),

              // Content preview
              Text(
                announcement.content,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),

              // Footer with author and target audience
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16.r,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        announcement.authorName ?? 'Unknown',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        _getAudienceIcon(announcement.targetAudience),
                        size: 16.r,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _getAudienceText(announcement.targetAudience),
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Expiry warning if applicable
              if (announcement.isExpired)
                Container(
                  margin: EdgeInsets.only(top: 8.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_outlined,
                        size: 14.r,
                        color: AppColors.error,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Expired',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
