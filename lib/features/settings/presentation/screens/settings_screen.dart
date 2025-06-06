import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';
import 'package:school_attendance/core/di/injection.dart';
import 'package:school_attendance/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:school_attendance/features/settings/presentation/widgets/settings_section.dart';
import 'package:school_attendance/features/settings/presentation/widgets/settings_switch.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    context.read<SettingsBloc>().add(LoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is SettingsUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Settings updated successfully'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SettingsLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Appearance Section
                    SettingsSection(
                      title: 'Appearance',
                      children: [
                        ListTile(
                          leading: const Icon(Icons.brightness_6_outlined),
                          title: const Text('Theme Mode'),
                          trailing: DropdownButton<String>(
                            value: state.themeMode,
                            items: const [
                              DropdownMenuItem(
                                value: 'system',
                                child: Text('System'),
                              ),
                              DropdownMenuItem(
                                value: 'light',
                                child: Text('Light'),
                              ),
                              DropdownMenuItem(
                                value: 'dark',
                                child: Text('Dark'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                context.read<SettingsBloc>().add(
                                      UpdateThemeMode(themeMode: value),
                                    );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Notifications Section
                    SettingsSection(
                      title: 'Notifications',
                      children: [
                        SettingsSwitch(
                          title: 'Push Notifications',
                          subtitle: 'Receive push notifications',
                          icon: Icons.notifications_outlined,
                          value: state.pushNotificationsEnabled,
                          onChanged: (value) {
                            context.read<SettingsBloc>().add(
                                  UpdatePushNotifications(enabled: value),
                                );
                          },
                        ),
                        SettingsSwitch(
                          title: 'Email Notifications',
                          subtitle: 'Receive email notifications',
                          icon: Icons.email_outlined,
                          value: state.emailNotificationsEnabled,
                          onChanged: (value) {
                            context.read<SettingsBloc>().add(
                                  UpdateEmailNotifications(enabled: value),
                                );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Security Section
                    SettingsSection(
                      title: 'Security',
                      children: [
                        ListTile(
                          leading: const Icon(Icons.lock_outline),
                          title: const Text('Change Password'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Navigate to change password screen
                          },
                        ),
                        SettingsSwitch(
                          title: 'Biometric Authentication',
                          subtitle: 'Use fingerprint or face ID',
                          icon: Icons.fingerprint,
                          value: state.biometricEnabled,
                          onChanged: (value) {
                            context.read<SettingsBloc>().add(
                                  UpdateBiometricAuth(enabled: value),
                                );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Data & Storage Section
                    SettingsSection(
                      title: 'Data & Storage',
                      children: [
                        ListTile(
                          leading: const Icon(Icons.storage_outlined),
                          title: const Text('Clear Cache'),
                          subtitle: Text(
                            'Cache size: ${state.cacheSize}',
                            style: TextStyle(
                              color: AppColors.textMuted,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.read<SettingsBloc>().add(ClearCache());
                          },
                        ),
                        SettingsSwitch(
                          title: 'Offline Mode',
                          subtitle: 'Enable offline access',
                          icon: Icons.cloud_off_outlined,
                          value: state.offlineModeEnabled,
                          onChanged: (value) {
                            context.read<SettingsBloc>().add(
                                  UpdateOfflineMode(enabled: value),
                                );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // About Section
                    SettingsSection(
                      title: 'About',
                      children: [
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text('App Version'),
                          trailing: Text(
                            state.appVersion,
                            style: TextStyle(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.description_outlined),
                          title: const Text('Terms of Service'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Navigate to terms of service
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.privacy_tip_outlined),
                          title: const Text('Privacy Policy'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Navigate to privacy policy
                          },
                        ),
                      ],
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
}
