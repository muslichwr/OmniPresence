import 'package:school_attendance/features/announcements/data/repositories/announcement_repository.dart';
import 'package:school_attendance/models/announcement_model.dart';

class CreateAnnouncementUseCase {
  final AnnouncementRepository repository;

  CreateAnnouncementUseCase(this.repository);

  Future<AnnouncementModel> execute(CreateAnnouncementRequest request) {
    return repository.createAnnouncement(
      title: request.title,
      content: request.content,
      priority: request.priority,
      targetAudience: request.targetAudience,
      authorId: request.authorId,
      expiresAt: request.expiresAt,
      targetClassId: request.targetClassId,
    );
  }
}

class GetAnnouncementsForUserUseCase {
  final AnnouncementRepository repository;

  GetAnnouncementsForUserUseCase(this.repository);

  Future<List<AnnouncementModel>> execute(String userId) {
    return repository.getAnnouncementsForUser(userId);
  }
}

class MarkAnnouncementAsReadUseCase {
  final AnnouncementRepository repository;

  MarkAnnouncementAsReadUseCase(this.repository);

  Future<void> execute(String announcementId, String userId) {
    return repository.markAnnouncementAsRead(announcementId, userId);
  }
}

class ExpireAnnouncementUseCase {
  final AnnouncementRepository repository;

  ExpireAnnouncementUseCase(this.repository);

  Future<void> execute(String id) {
    return repository.expireAnnouncement(id);
  }
}

class GetActiveAnnouncementsUseCase {
  final AnnouncementRepository repository;

  GetActiveAnnouncementsUseCase(this.repository);

  Future<List<AnnouncementModel>> execute() {
    return repository.getActiveAnnouncements();
  }
}

// Request classes
class CreateAnnouncementRequest {
  final String title;
  final String content;
  final AnnouncementPriority priority;
  final TargetAudience targetAudience;
  final String authorId;
  final DateTime expiresAt;
  final String? targetClassId;

  CreateAnnouncementRequest({
    required this.title,
    required this.content,
    required this.priority,
    required this.targetAudience,
    required this.authorId,
    required this.expiresAt,
    this.targetClassId,
  });
}
