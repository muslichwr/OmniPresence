import 'package:appwrite/appwrite.dart';
import 'package:school_attendance/config/app_constants.dart';
import 'package:school_attendance/core/services/logger_service.dart';
import 'package:school_attendance/models/user_model.dart';

class ProfileRepository {
  final Databases _databases;
  final LoggerService _logger;

  ProfileRepository(this._databases, this._logger);

  Future<UserModel> getUserProfile(String userId) async {
    try {
      final response = await _databases.getDocument(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.usersCollection,
        documentId: userId,
      );

      return UserModel.fromJson(response.data);
    } catch (e) {
      _logger.error('Failed to get user profile', e);
      throw Exception('Failed to get user profile: $e');
    }
  }

  Future<UserModel> updateUserProfile(
    String userId, {
    String? name,
    String? phone,
    String? classId,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (classId != null) updateData['class_id'] = classId;

      final response = await _databases.updateDocument(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.usersCollection,
        documentId: userId,
        data: updateData,
      );

      _logger.info('User profile updated successfully');
      return UserModel.fromJson(response.data);
    } catch (e) {
      _logger.error('Failed to update user profile', e);
      throw Exception('Failed to update user profile: $e');
    }
  }

  Future<String?> getClassName(String? classId) async {
    if (classId == null) return null;

    try {
      final response = await _databases.getDocument(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.classesCollection,
        documentId: classId,
      );

      return response.data['class_name'];
    } catch (e) {
      _logger.error('Failed to get class name', e);
      return null;
    }
  }
}
