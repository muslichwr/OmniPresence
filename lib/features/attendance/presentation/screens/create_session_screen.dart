import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/core/di/injection.dart';
import 'package:school_attendance/features/attendance/presentation/bloc/session_bloc.dart';
import 'package:school_attendance/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:school_attendance/features/common/widgets/custom_button.dart';
import 'package:school_attendance/features/common/widgets/loading_indicator.dart';

@RoutePage()
class CreateSessionScreen extends StatefulWidget {
  const CreateSessionScreen({super.key});

  @override
  State<CreateSessionScreen> createState() => _CreateSessionScreenState();
}

class _CreateSessionScreenState extends State<CreateSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _durationController = TextEditingController(text: '15');

  @override
  void dispose() {
    _subjectController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _createSession() {
    if (_formKey.currentState!.validate()) {
      final duration = int.tryParse(_durationController.text) ?? 15;
      context.read<SessionBloc>().add(
            CreateSession(
              subjectId: _subjectController.text.trim(),
              durationMinutes: duration,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SessionBloc>(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Attendance Session'),
            centerTitle: true,
          ),
          body: BlocConsumer<SessionBloc, SessionState>(
            listener: (context, state) {
              if (state is SessionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              } else if (state is SessionCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Session created successfully!'),
                    backgroundColor: AppColors.success,
                  ),
                );

                // Navigate to live monitoring
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
                                Icons.add_circle_outline,
                                size: 80.r,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 32.h),
                            Text(
                              'Create New Session',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Create an attendance session for your class. Students will use the generated code to mark their attendance.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                            ),
                            SizedBox(height: 32.h),
                            CustomTextField(
                              controller: _subjectController,
                              label: 'Subject/Class',
                              hintText: 'Enter subject or class name',
                              prefixIcon: Icons.book_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Subject/Class is required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                            CustomTextField(
                              controller: _durationController,
                              label: 'Session Duration (minutes)',
                              hintText: 'Enter duration in minutes',
                              prefixIcon: Icons.timer_outlined,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Duration is required';
                                }
                                final duration = int.tryParse(value);
                                if (duration == null ||
                                    duration < 5 ||
                                    duration > 120) {
                                  return 'Duration must be between 5 and 120 minutes';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 32.h),
                            CustomButton(
                              text: 'Create Session',
                              onPressed: _createSession,
                              isFullWidth: true,
                              icon: Icons.add_circle_outline,
                              isLoading: state is SessionLoading,
                            ),
                            SizedBox(height: 16.h),
                            if (state is SessionCreated)
                              Container(
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: AppColors.success,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColors.success,
                                      size: 48.r,
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'Session Created!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: AppColors.success,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Session Code:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 12.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceLight,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        border: Border.all(
                                          color: AppColors.borderLight,
                                        ),
                                      ),
                                      child: Text(
                                        state.session.displayCode,
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 4.w,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    CustomButton(
                                      text: 'Monitor Session',
                                      onPressed: () {
                                        // Navigate to live monitoring
                                      },
                                      type: ButtonType.outlined,
                                      icon: Icons.monitor_outlined,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (state is SessionLoading) const LoadingIndicator(),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
