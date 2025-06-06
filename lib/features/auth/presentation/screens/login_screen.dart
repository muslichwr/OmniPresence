import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/config/routes.dart';
import 'package:school_attendance/core/di/injection.dart';
import 'package:school_attendance/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:school_attendance/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:school_attendance/features/common/widgets/custom_button.dart';
import 'package:school_attendance/features/common/widgets/loading_indicator.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  void _navigateToRegister() {
    context.router.push(RegisterRoute());
  }

  void _resetPassword() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email first'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
          ResetPasswordEvent(
            email: _emailController.text.trim(),
          ),
        );
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
          } else if (state is PasswordResetSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Password reset link has been sent to your email'),
                backgroundColor: AppColors.success,
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
                              'School Attendance',
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
                              'Sign in to continue',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        SizedBox(height: 48.h),
                        // Login Form
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  final emailRegex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
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
                                  return null;
                                },
                              ),
                              SizedBox(height: 8.h),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _resetPassword,
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              CustomButton(
                                text: 'Sign In',
                                onPressed: _handleLogin,
                                isFullWidth: true,
                              ),
                              SizedBox(height: 16.h),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Register Option
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: _navigateToRegister,
                              child: Text(
                                'Register',
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
