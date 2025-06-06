import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/core/di/injection.dart';
import 'package:school_attendance/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:school_attendance/features/attendance/presentation/widgets/code_input.dart';
import 'package:school_attendance/features/common/widgets/custom_button.dart';
import 'package:school_attendance/features/common/widgets/loading_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';

@RoutePage()
class AttendanceInputScreen extends StatefulWidget {
  const AttendanceInputScreen({super.key});

  @override
  State<AttendanceInputScreen> createState() => _AttendanceInputScreenState();
}

class _AttendanceInputScreenState extends State<AttendanceInputScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submitCode() {
    final code = _codeController.text.trim().replaceAll('-', '');
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit code'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    context.read<AttendanceBloc>().add(
          SubmitAttendanceEvent(sessionCode: code),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AttendanceBloc>(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Mark Attendance'),
            centerTitle: true,
          ),
          body: BlocConsumer<AttendanceBloc, AttendanceState>(
            listener: (context, state) {
              if (state is AttendanceError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              } else if (state is AttendanceSubmitted) {
                // Show success animation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Attendance marked successfully!'),
                    backgroundColor: AppColors.success,
                  ),
                );

                // Clear the input field
                _codeController.clear();
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(24.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Icon(
                              Icons.qr_code_scanner_rounded,
                              size: 100.r,
                              color: AppColors.primary,
                            ).animate().scale(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeOutBack,
                                ),
                          ),
                          SizedBox(height: 32.h),
                          Text(
                            'Enter Attendance Code',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ).animate().fadeIn(
                              duration: const Duration(milliseconds: 500)),
                          SizedBox(height: 8.h),
                          Text(
                            'Please enter the 6-digit code provided by your teacher to mark your attendance',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                          )
                              .animate(delay: const Duration(milliseconds: 300))
                              .fadeIn(
                                  duration: const Duration(milliseconds: 500)),
                          SizedBox(height: 48.h),
                          CodeInput(
                            controller: _codeController,
                            onComplete: _submitCode,
                          )
                              .animate(delay: const Duration(milliseconds: 600))
                              .fadeIn(
                                  duration: const Duration(milliseconds: 500))
                              .moveY(begin: 20, end: 0),
                          SizedBox(height: 48.h),
                          CustomButton(
                            text: 'Submit',
                            onPressed: _submitCode,
                            isFullWidth: true,
                            icon: Icons.check_circle_outline,
                            isLoading: state is AttendanceLoading,
                          )
                              .animate(delay: const Duration(milliseconds: 900))
                              .fadeIn(
                                  duration: const Duration(milliseconds: 500))
                              .moveY(begin: 20, end: 0),
                          SizedBox(height: 24.h),
                          if (state is AttendanceSubmitted)
                            Center(
                              child: Column(
                                children: [
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
                                          'Attendance Recorded!',
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
                                          state.status == 'present'
                                              ? 'You are marked as Present'
                                              : 'You are marked as Late',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          'Subject: ${state.subjectName}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ).animate().scale(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOutBack,
                                  ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (state is AttendanceLoading) const LoadingIndicator(),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
