part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final String themeMode;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool biometricEnabled;
  final bool offlineModeEnabled;
  final String cacheSize;
  final String appVersion;

  const SettingsLoaded({
    required this.themeMode,
    required this.pushNotificationsEnabled,
    required this.emailNotificationsEnabled,
    required this.biometricEnabled,
    required this.offlineModeEnabled,
    required this.cacheSize,
    required this.appVersion,
  });

  @override
  List<Object> get props => [
        themeMode,
        pushNotificationsEnabled,
        emailNotificationsEnabled,
        biometricEnabled,
        offlineModeEnabled,
        cacheSize,
        appVersion,
      ];

  SettingsLoaded copyWith({
    String? themeMode,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? biometricEnabled,
    bool? offlineModeEnabled,
    String? cacheSize,
    String? appVersion,
  }) {
    return SettingsLoaded(
      themeMode: themeMode ?? this.themeMode,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled:
          emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      offlineModeEnabled: offlineModeEnabled ?? this.offlineModeEnabled,
      cacheSize: cacheSize ?? this.cacheSize,
      appVersion: appVersion ?? this.appVersion,
    );
  }
}

class SettingsUpdated extends SettingsState {}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
