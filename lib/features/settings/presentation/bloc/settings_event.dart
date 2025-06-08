part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateThemeMode extends SettingsEvent {
  final String themeMode;

  const UpdateThemeMode({
    required this.themeMode,
  });

  @override
  List<Object> get props => [themeMode];
}

class UpdatePushNotifications extends SettingsEvent {
  final bool enabled;

  const UpdatePushNotifications({
    required this.enabled,
  });

  @override
  List<Object> get props => [enabled];
}

class UpdateEmailNotifications extends SettingsEvent {
  final bool enabled;

  const UpdateEmailNotifications({
    required this.enabled,
  });

  @override
  List<Object> get props => [enabled];
}

class UpdateBiometricAuth extends SettingsEvent {
  final bool enabled;

  const UpdateBiometricAuth({
    required this.enabled,
  });

  @override
  List<Object> get props => [enabled];
}

class UpdateOfflineMode extends SettingsEvent {
  final bool enabled;

  const UpdateOfflineMode({
    required this.enabled,
  });

  @override
  List<Object> get props => [enabled];
}

class ClearCache extends SettingsEvent {}
