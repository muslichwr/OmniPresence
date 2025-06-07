part of 'announcement_bloc.dart';

abstract class AnnouncementEvent extends Equatable {
  const AnnouncementEvent();

  @override
  List<Object> get props => [];
}

class LoadAnnouncements extends AnnouncementEvent {}

class CreateAnnouncement extends AnnouncementEvent {
  final String title;
  final String content;
  final AnnouncementPriority priority;
  final TargetAudience targetAudience;
  final DateTime expiresAt;

  const CreateAnnouncement({
    required this.title,
    required this.content,
    required this.priority,
    required this.targetAudience,
    required this.expiresAt,
  });

  @override
  List<Object> get props =>
      [title, content, priority, targetAudience, expiresAt];
}

class LoadAnnouncementDetails extends AnnouncementEvent {
  final String announcementId;

  const LoadAnnouncementDetails({
    required this.announcementId,
  });

  @override
  List<Object> get props => [announcementId];
}

class MarkAnnouncementAsRead extends AnnouncementEvent {
  final String announcementId;

  const MarkAnnouncementAsRead({
    required this.announcementId,
  });

  @override
  List<Object> get props => [announcementId];
}
