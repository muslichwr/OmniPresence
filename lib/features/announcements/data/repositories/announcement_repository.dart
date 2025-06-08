import 'package:appwrite/appwrite.dart';
import 'package:school_attendance/config/app_constants.dart';
import 'package:school_attendance/core/services/logger_service.dart';
import 'package:school_attendance/models/announcement_model.dart';

class AnnouncementRepository {
  final Databases _databases;
  final LoggerService _logger;

  AnnouncementRepository(this._databases, this._logger);

  Future<AnnouncementModel> createAnnouncement({
    required String title,
    required String content,
    required AnnouncementPriority priority,
    required TargetAudience targetAudience,
    required String authorId,
    required DateTime expiresAt,
    String? targetClassId,
  }) async {
    try {
      final now = DateTime.now();

      final response = await _databases.createDocument(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.announcementsCollection,
        documentId: 'unique()',
        data: {
          'title': title,
          'content': content,
          'priority': priority.name,
          'target_audience': targetAudience.name,
          'target_class_id': targetClassId,
          'author_id': authorId,
          'published_at': now.toIso8601String(),
          'expires_at': expiresAt.toIso8601String(),
          'is_active': true,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        },
      );

      _logger
          .info('Announcement created successfully: ${response.data['title']}');
      return AnnouncementModel.fromJson(response.data);
    } catch (e) {
      _logger.error('Failed to create announcement', e);
      throw Exception('Failed to create announcement: $e');
    }
  }

  Future<List<AnnouncementModel>> getAnnouncementsForUser(String userId) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.announcementsCollection,
        queries: [
          Query.equal('is_active', true),
          Query.greaterThan('expires_at', DateTime.now().toIso8601String()),
          Query.orderDesc('published_at'),
        ],
      );

      return response.documents
          .map((doc) => AnnouncementModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      _logger.error('Failed to fetch announcements', e);
      throw Exception('Failed to fetch announcements: $e');
    }
  }

  Future<AnnouncementModel> getAnnouncementById(String id) async {
    try {
      final response = await _databases.getDocument(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.announcementsCollection,
        documentId: id,
      );

      return AnnouncementModel.fromJson(response.data);
    } catch (e) {
      _logger.error('Failed to fetch announcement', e);
      throw Exception('Failed to fetch announcement: $e');
    }
  }

  Future<void> markAnnouncementAsRead(
      String announcementId, String userId) async {
    try {
      // In a real implementation, you would track read status per user
      // For now, we'll just log the action
      _logger.info('User $userId marked announcement $announcementId as read');
    } catch (e) {
      _logger.error('Failed to mark announcement as read', e);
      throw Exception('Failed to mark announcement as read: $e');
    }
  }

  Future<void> expireAnnouncement(String id) async {
    try {
      await _databases.updateDocument(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.announcementsCollection,
        documentId: id,
        data: {
          'is_active': false,
          'updated_at': DateTime.now().toIso8601String(),
        },
      );

      _logger.info('Announcement expired: $id');
    } catch (e) {
      _logger.error('Failed to expire announcement', e);
      throw Exception('Failed to expire announcement: $e');
    }
  }

  Future<List<AnnouncementModel>> getActiveAnnouncements() async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.announcementsCollection,
        queries: [
          Query.equal('is_active', true),
          Query.greaterThan('expires_at', DateTime.now().toIso8601String()),
          Query.orderDesc('priority'),
          Query.orderDesc('published_at'),
        ],
      );

      return response.documents
          .map((doc) => AnnouncementModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      _logger.error('Failed to fetch active announcements', e);
      throw Exception('Failed to fetch active announcements: $e');
    }
  }
}
