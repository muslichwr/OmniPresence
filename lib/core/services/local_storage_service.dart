import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_attendance/config/app_constants.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // User related methods
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(AppConstants.prefUserId, userId);
  }

  String? getUserId() {
    return _prefs.getString(AppConstants.prefUserId);
  }

  Future<void> saveUserRole(String role) async {
    await _prefs.setString(AppConstants.prefUserRole, role);
  }

  String? getUserRole() {
    return _prefs.getString(AppConstants.prefUserRole);
  }

  Future<void> saveUserName(String name) async {
    await _prefs.setString(AppConstants.prefUserName, name);
  }

  String? getUserName() {
    return _prefs.getString(AppConstants.prefUserName);
  }

  Future<void> setLoggedIn(bool isLoggedIn) async {
    await _prefs.setBool(AppConstants.prefIsLoggedIn, isLoggedIn);
  }

  bool isLoggedIn() {
    return _prefs.getBool(AppConstants.prefIsLoggedIn) ?? false;
  }

  // App settings methods
  Future<void> saveThemeMode(String themeMode) async {
    await _prefs.setString(AppConstants.prefThemeMode, themeMode);
  }

  String getThemeMode() {
    return _prefs.getString(AppConstants.prefThemeMode) ?? 'system';
  }

  // Cache related methods
  Future<void> cacheData(String key, String data) async {
    await _prefs.setString(key, data);
  }

  String? getCachedData(String key) {
    return _prefs.getString(key);
  }

  Future<void> removeCachedData(String key) async {
    await _prefs.remove(key);
  }

  // Offline actions queue
  Future<void> addPendingAction(String action) async {
    final pendingActions = _prefs.getStringList('pending_actions') ?? [];
    pendingActions.add(action);
    await _prefs.setStringList('pending_actions', pendingActions);
  }

  List<String> getPendingActions() {
    return _prefs.getStringList('pending_actions') ?? [];
  }

  Future<void> clearPendingActions() async {
    await _prefs.setStringList('pending_actions', []);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
