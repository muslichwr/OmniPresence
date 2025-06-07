part of 'announcement_bloc.dart';

abstract class AnnouncementState extends Equatable {
  const AnnouncementState();

  @override
  List<Object?> get props => [];
}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementLoading extends AnnouncementState {}

class AnnouncementsLoaded extends AnnouncementState {
  final List<AnnouncementModel> announcements;

  const AnnouncementsLoaded({
    required this.announcements,
  });

  @override
  List<Object> get props => [announcements];
}

class AnnouncementCreated extends AnnouncementState {
  final AnnouncementModel announcement;

  const AnnouncementCreated({
    required this.announcement,
  });

  @override
  List<Object> get props => [announcement];
}

class AnnouncementDetailsLoaded extends AnnouncementState {
  final AnnouncementModel announcement;

  const AnnouncementDetailsLoaded({
    required this.announcement,
  });

  @override
  List<Object> get props => [announcement];
}

class AnnouncementMarkedAsRead extends AnnouncementState {}

class AnnouncementError extends AnnouncementState {
  final String message;

  const AnnouncementError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
