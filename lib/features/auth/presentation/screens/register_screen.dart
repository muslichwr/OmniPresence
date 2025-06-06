import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/config/app_constants.dart';
import 'package:school_attendance/core/di/injection.dart';
import 'package:school_attendance/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:school_attendance/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:school_attendance/features/common/widgets/custom_button.dart';
import 'package:school_attendance/features/common/widgets/loading_indicator.dart';
import 'package:school_attendance/models/user_model.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _phoneController = TextEditingController();

  UserRole _selectedRole = UserRole.student;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _studentIdController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              name: _nameController.text.trim(),
              role: _selectedRole,
              studentId: _selectedRole == UserRole.student
                  ? _studentIdController.text.trim()
                  : null,
              phone: _phoneController.text.trim(),
            ),
          );
    }
  }

  void _navigateToLogin() {
    context.router.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigate based on user role
            if (state.user.isStudent) {
              context.router.replace(StudentDashboardRoute());
            } else if (state.user.isTeacher) {
              context.router.replace(TeacherDashboardRoute());
            } else {
              context.router.replace(AdminDashboardRoute());
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 40.h),
                        // App Logo and Name
                        Column(
                          children: [
                            Icon(
                              Icons.school_rounded,
                              size: 80.r,
                              color: AppColors.primary,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Create Account',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Join School Attendance',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        SizedBox(height: 48.h),
                        // Registration Form
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
                                controller: _emailController,
                                label: 'Email',
                                hintText: 'Enter your email',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  final emailRegex =
                                      RegExp(AppConstants.emailPattern);
                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.h),
                              CustomTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon: Icons.lock_outline,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Role',
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
                                  children: [
                                    RadioListTile<UserRole>(
                                      title: const Text('Student'),
                                      value: UserRole.student,
                                      groupValue: _selectedRole,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedRole = value!;
                                        });
                                      },
                                    ),
                                    RadioListTile<UserRole>(
                                      title: const Text('Teacher'),
                                      value: UserRole.teacher,
                                      groupValue: _selectedRole,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedRole = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h),
                              if (_selectedRole == UserRole.student)
                                CustomTextField(
                                  controller: _studentIdController,
                                  label: 'Student ID',
                                  hintText: 'Enter your student ID',
                                  prefixIcon: Icons.badge_outlined,
                                  validator: (value) {
                                    if (_selectedRole == UserRole.student) {
                                      if (value == null || value.isEmpty) {
                                        return 'Student ID is required';
                                      }
                                      final studentIdRegex =
                                          RegExp(AppConstants.studentIdPattern);
                                      if (!studentIdRegex.hasMatch(value)) {
                                        return 'Enter a valid student ID (YYYY-XXXX-####)';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              if (_selectedRole == UserRole.student)
                                SizedBox(height: 16.h),
                              CustomTextField(
                                controller: _phoneController,
                                label: 'Phone Number',
                                hintText: 'Enter your phone number',
                                prefixIcon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    final phoneRegex =
                                        RegExp(AppConstants.phonePattern);
                                    if (!phoneRegex.hasMatch(value)) {
                                      return 'Enter a valid Indonesian phone number';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 32.h),
                              CustomButton(
                                text: 'Create Account',
                                onPressed: _handleRegister,
                                isFullWidth: true,
                                isLoading: state is AuthLoading,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Login Option
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: _navigateToLogin,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (state is AuthLoading) const LoadingIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }
}
