import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/core/di/injection.dart';
import 'package:school_attendance/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:school_attendance/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:school_attendance/features/common/widgets/custom_button.dart';
import 'package:school_attendance/features/profile/presentation/bloc/profile_bloc.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _loadProfile() {
    context.read<ProfileBloc>().add(LoadProfile());
  }

  void _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
            UpdateProfile(
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
            ),
          );
    }
  }

  void _handleLogout() {
    context.read<AuthBloc>().add(LogoutEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProfileLoaded) {
            // Pre-fill the form with current data
            _nameController.text = state.user.name;
            _phoneController.text = state.user.phone ?? '';

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 24.h),
                    // Profile Avatar
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        state.user.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 32.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Role Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        state.user.role.name.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    // Profile Form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            hintText: 'Enter your full name',
                            prefixIcon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          CustomTextField(
                            controller:
                                TextEditingController(text: state.user.email),
                            label: 'Email',
                            hintText: 'Your email address',
                            prefixIcon: Icons.email_outlined,
                            enabled: false,
                          ),
                          SizedBox(height: 16.h),
                          if (state.user.isStudent) ...[
                            CustomTextField(
                              controller: TextEditingController(
                                  text: state.user.studentId),
                              label: 'Student ID',
                              hintText: 'Your student ID',
                              prefixIcon: Icons.badge_outlined,
                              enabled: false,
                            ),
                            SizedBox(height: 16.h),
                          ],
                          CustomTextField(
                            controller: _phoneController,
                            label: 'Phone Number',
                            hintText: 'Enter your phone number',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final phoneRegex =
                                    RegExp(r'^(\+62|08)\d{8,12}$');
                                if (!phoneRegex.hasMatch(value)) {
                                  return 'Enter a valid Indonesian phone number';
                                }
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 32.h),
                          CustomButton(
                            text: 'Update Profile',
                            onPressed: _handleUpdate,
                            isFullWidth: true,
                            isLoading: state is ProfileUpdating,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Account Info
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account Information',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: 16.h),
                            _buildInfoRow(
                              'Member Since',
                              state.user.createdAt.toString().split(' ')[0],
                              Icons.calendar_today_outlined,
                            ),
                            SizedBox(height: 8.h),
                            _buildInfoRow(
                              'Last Updated',
                              state.user.updatedAt.toString().split(' ')[0],
                              Icons.update_outlined,
                            ),
                            if (state.user.isStudent) ...[
                              SizedBox(height: 8.h),
                              _buildInfoRow(
                                'Class',
                                state.className ?? 'Not Assigned',
                                Icons.class_outlined,
                              ),
                            ],
                          ],
                        ),
                      ),
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

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.r,
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
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
