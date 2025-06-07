import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_attendance/features/announcements/domain/usecases/announcement_usecases.dart';
import 'package:school_attendance/models/announcement_model.dart';

part 'announcement_event.dart';
part 'announcement_state.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final CreateAnnouncementUseCase createAnnouncementUseCase;
  final GetAnnouncementsForUserUseCase getAnnouncementsForUserUseCase;
  final MarkAnnouncementAsReadUseCase markAnnouncementAsReadUseCase;

  AnnouncementBloc({
    required this.createAnnouncementUseCase,
    required this.getAnnouncementsForUserUseCase,
    required this.markAnnouncementAsReadUseCase,
  }) : super(AnnouncementInitial()) {
    on<LoadAnnouncements>(_onLoadAnnouncements);
    on<CreateAnnouncement>(_onCreateAnnouncement);
    on<LoadAnnouncementDetails>(_onLoadAnnouncementDetails);
    on<MarkAnnouncementAsRead>(_onMarkAnnouncementAsRead);
  }

  Future<void> _onLoadAnnouncements(
      LoadAnnouncements event, Emitter<AnnouncementState> emit) async {
    emit(AnnouncementLoading());

    try {
      final announcements =
          await getAnnouncementsForUserUseCase.execute('current_user_id');
      emit(AnnouncementsLoaded(announcements: announcements));
    } catch (e) {
      emit(AnnouncementError(message: e.toString()));
    }
  }

  Future<void> _onCreateAnnouncement(
      CreateAnnouncement event, Emitter<AnnouncementState> emit) async {
    emit(AnnouncementLoading());

    try {
      final announcement = await createAnnouncementUseCase.execute(
        CreateAnnouncementRequest(
          title: event.title,
          content: event.content,
          priority: event.priority,
          targetAudience: event.targetAudience,
          expiresAt: event.expiresAt,
        ),
      );

      emit(AnnouncementCreated(announcement: announcement));
    } catch (e) {
      emit(AnnouncementError(message: e.toString()));
    }
  }

  Future<void> _onLoadAnnouncementDetails(
      LoadAnnouncementDetails event, Emitter<AnnouncementState> emit) async {
    emit(AnnouncementLoading());

    try {
      // In a real implementation, you'd have a use case to get announcement by ID
      // For now, we'll create a mock announcement
      final announcement = AnnouncementModel(
        id: event.announcementId,
        title: 'Sample Announcement',
        content: 'This is a sample announcement content.',
        priority: AnnouncementPriority.medium,
        targetAudience: TargetAudience.all,
        authorId: 'author1',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        authorName: 'John Doe',
      );

      emit(AnnouncementDetailsLoaded(announcement: announcement));
    } catch (e) {
      emit(AnnouncementError(message: e.toString()));
    }
  }

  Future<void> _onMarkAnnouncementAsRead(
      MarkAnnouncementAsRead event, Emitter<AnnouncementState> emit) async {
    try {
      await markAnnouncementAsReadUseCase.execute(
        event.announcementId,
        'current_user_id',
      );

      emit(AnnouncementMarkedAsRead());
    } catch (e) {
      emit(AnnouncementError(message: e.toString()));
    }
  }
}

// Request classes
class CreateAnnouncementRequest {
  final String title;
  final String content;
  final AnnouncementPriority priority;
  final TargetAudience targetAudience;
  final DateTime expiresAt;

  CreateAnnouncementRequest({
    required this.title,
    required this.content,
    required this.priority,
    required this.targetAudience,
    required this.expiresAt,
  });
}
