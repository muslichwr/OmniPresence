import 'package:appwrite/appwrite.dart';
import 'package:school_attendance/config/app_constants.dart';
import 'package:school_attendance/core/services/local_storage_service.dart';
import 'package:school_attendance/core/services/logger_service.dart';
import 'package:school_attendance/models/user_model.dart';

class AuthRepository {
  final Account _account;
  final Databases _databases;
  final LocalStorageService _localStorage;

  AuthRepository(this._account, this._databases, this._localStorage);

  Future<UserModel> login(String email, String password) async {
    try {
      // Create session
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // Get user account
      final account = await _account.get();

      // Get user profile from database
      final userDoc = await _databases.getDocument(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.usersCollection,
        documentId: account.$id,
      );

      final user = UserModel.fromJson(userDoc.data);

      // Save user data locally
      await _localStorage.saveUserId(user.id);
      await _localStorage.saveUserRole(user.role.name);
      await _localStorage.saveUserName(user.name);
      await _localStorage.setLoggedIn(true);

      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? studentId,
    String? classId,
    String? phone,
  }) async {
    try {
      // Create account
      final account = await _account.create(
        userId: 'unique()',
        email: email,
        password: password,
        name: name,
      );

      // Create user profile in database
      final now = DateTime.now();
      final userDoc = await _databases.createDocument(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.usersCollection,
        documentId: account.$id,
        data: {
          'email': email,
          'name': name,
          'role': role.name,
          'student_id': studentId,
          'class_id': classId,
          'phone': phone,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        },
      );

      // Create session
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final user = UserModel.fromJson(userDoc.data);

      // Save user data locally
      await _localStorage.saveUserId(user.id);
      await _localStorage.saveUserRole(user.role.name);
      await _localStorage.saveUserName(user.name);
      await _localStorage.setLoggedIn(true);

      return user;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      await _localStorage.clearAll();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final account = await _account.get();

      final userDoc = await _databases.getDocument(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.usersCollection,
        documentId: account.$id,
      );

      return UserModel.fromJson(userDoc.data);
    } catch (e) {
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _account.createRecovery(
        email: email,
        url: 'https://your-app.com/reset-password',
      );
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }
}
