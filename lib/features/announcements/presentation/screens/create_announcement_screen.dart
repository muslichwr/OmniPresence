import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/core/di/injection.dart';
import 'package:school_attendance/features/announcements/presentation/bloc/announcement_bloc.dart';
import 'package:school_attendance/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:school_attendance/features/common/widgets/custom_button.dart';
import 'package:school_attendance/features/common/widgets/loading_indicator.dart';
import 'package:school_attendance/models/announcement_model.dart';

@RoutePage()
class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  State<CreateAnnouncementScreen> createState() =>
      _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  AnnouncementPriority _selectedPriority = AnnouncementPriority.medium;
  TargetAudience _selectedAudience = TargetAudience.all;
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _createAnnouncement() {
    if (_formKey.currentState!.validate()) {
      context.read<AnnouncementBloc>().add(
            CreateAnnouncement(
              title: _titleController.text.trim(),
              content: _contentController.text.trim(),
              priority: _selectedPriority,
              targetAudience: _selectedAudience,
              expiresAt: _expiryDate,
            ),
          );
    }
  }

  Future<void> _selectExpiryDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      setState(() {
        _expiryDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AnnouncementBloc>(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Announcement'),
            centerTitle: true,
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
              } else if (state is AnnouncementCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Announcement created successfully!'),
                    backgroundColor: AppColors.success,
                  ),
                );
                context.router.pop();
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(24.r),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Icon(
                                Icons.announcement_outlined,
                                size: 80.r,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 32.h),
                            Text(
                              'Create New Announcement',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Share important information with your school community.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                            ),
                            SizedBox(height: 32.h),

                            // Title Field
                            CustomTextField(
                              controller: _titleController,
                              label: 'Title',
                              hintText: 'Enter announcement title',
                              prefixIcon: Icons.title_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Title is required';
                                }
                                if (value.length < 5) {
                                  return 'Title must be at least 5 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),

                            // Content Field
                            CustomTextField(
                              controller: _contentController,
                              label: 'Content',
                              hintText: 'Enter announcement content',
                              prefixIcon: Icons.description_outlined,
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Content is required';
                                }
                                if (value.length < 10) {
                                  return 'Content must be at least 10 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),

                            // Priority Selection
                            Text(
                              'Priority Level',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.borderLight,
                                ),
                              ),
                              child: Column(
                                children:
                                    AnnouncementPriority.values.map((priority) {
                                  return RadioListTile<AnnouncementPriority>(
                                    title: Text(_getPriorityText(priority)),
                                    subtitle:
                                        Text(_getPriorityDescription(priority)),
                                    value: priority,
                                    groupValue: _selectedPriority,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedPriority = value!;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Target Audience Selection
                            Text(
                              'Target Audience',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.borderLight,
                                ),
                              ),
                              child: Column(
                                children: TargetAudience.values.map((audience) {
                                  return RadioListTile<TargetAudience>(
                                    title: Text(_getAudienceText(audience)),
                                    value: audience,
                                    groupValue: _selectedAudience,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedAudience = value!;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Expiry Date Selection
                            Text(
                              'Expiry Date',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            InkWell(
                              onTap: _selectExpiryDate,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.borderLight,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: AppColors.textMuted,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      '${_expiryDate.day}/${_expiryDate.month}/${_expiryDate.year}',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: AppColors.textMuted,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 32.h),

                            // Create Button
                            CustomButton(
                              text: 'Create Announcement',
                              onPressed: _createAnnouncement,
                              isFullWidth: true,
                              icon: Icons.send_outlined,
                              isLoading: state is AnnouncementLoading,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (state is AnnouncementLoading) const LoadingIndicator(),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  String _getPriorityText(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.low:
        return 'Low Priority';
      case AnnouncementPriority.medium:
        return 'Medium Priority';
      case AnnouncementPriority.high:
        return 'High Priority';
      case AnnouncementPriority.urgent:
        return 'Urgent';
    }
  }

  String _getPriorityDescription(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.low:
        return 'General information, no immediate action required';
      case AnnouncementPriority.medium:
        return 'Important information, moderate attention needed';
      case AnnouncementPriority.high:
        return 'Important announcement requiring attention';
      case AnnouncementPriority.urgent:
        return 'Critical announcement requiring immediate attention';
    }
  }

  String _getAudienceText(TargetAudience audience) {
    switch (audience) {
      case TargetAudience.all:
        return 'Everyone';
      case TargetAudience.students:
        return 'Students Only';
      case TargetAudience.teachers:
        return 'Teachers Only';
      case TargetAudience.specificClass:
        return 'Specific Class';
    }
  }
}
