import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_attendance/core/services/local_storage_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final LocalStorageService _localStorage;

  SettingsBloc(this._localStorage) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateThemeMode>(_onUpdateThemeMode);
    on<UpdatePushNotifications>(_onUpdatePushNotifications);
    on<UpdateEmailNotifications>(_onUpdateEmailNotifications);
    on<UpdateBiometricAuth>(_onUpdateBiometricAuth);
    on<UpdateOfflineMode>(_onUpdateOfflineMode);
    on<ClearCache>(_onClearCache);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());

    try {
      // Load settings from local storage
      final themeMode = _localStorage.getThemeMode();

      emit(SettingsLoaded(
        themeMode: themeMode,
        pushNotificationsEnabled: true, // Mock data
        emailNotificationsEnabled: false,
        biometricEnabled: false,
        offlineModeEnabled: true,
        cacheSize: '12.5 MB',
        appVersion: '1.0.0',
      ));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateThemeMode(
    UpdateThemeMode event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      try {
        await _localStorage.saveThemeMode(event.themeMode);

        emit(currentState.copyWith(themeMode: event.themeMode));
        emit(SettingsUpdated());
        emit(currentState.copyWith(themeMode: event.themeMode));
      } catch (e) {
        emit(SettingsError(message: e.toString()));
      }
    }
  }

  Future<void> _onUpdatePushNotifications(
    UpdatePushNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      emit(currentState.copyWith(pushNotificationsEnabled: event.enabled));
      emit(SettingsUpdated());
      emit(currentState.copyWith(pushNotificationsEnabled: event.enabled));
    }
  }

  Future<void> _onUpdateEmailNotifications(
    UpdateEmailNotifications event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      emit(currentState.copyWith(emailNotificationsEnabled: event.enabled));
      emit(SettingsUpdated());
      emit(currentState.copyWith(emailNotificationsEnabled: event.enabled));
    }
  }

  Future<void> _onUpdateBiometricAuth(
    UpdateBiometricAuth event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      emit(currentState.copyWith(biometricEnabled: event.enabled));
      emit(SettingsUpdated());
      emit(currentState.copyWith(biometricEnabled: event.enabled));
    }
  }

  Future<void> _onUpdateOfflineMode(
    UpdateOfflineMode event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      emit(currentState.copyWith(offlineModeEnabled: event.enabled));
      emit(SettingsUpdated());
      emit(currentState.copyWith(offlineModeEnabled: event.enabled));
    }
  }

  Future<void> _onClearCache(
    ClearCache event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      // Mock cache clearing
      emit(currentState.copyWith(cacheSize: '0 MB'));
      emit(SettingsUpdated());
      emit(currentState.copyWith(cacheSize: '0 MB'));
    }
  }
}
