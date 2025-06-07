part of 'session_bloc.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object> get props => [];
}

class CreateSession extends SessionEvent {
  final String subjectId;
  final int durationMinutes;

  const CreateSession({
    required this.subjectId,
    required this.durationMinutes,
  });

  @override
  List<Object> get props => [subjectId, durationMinutes];
}

class LoadActiveSessions extends SessionEvent {
  final String teacherId;

  const LoadActiveSessions({
    required this.teacherId,
  });

  @override
  List<Object> get props => [teacherId];
}

class EndSession extends SessionEvent {
  final String sessionId;

  const EndSession({
    required this.sessionId,
  });

  @override
  List<Object> get props => [sessionId];
}

class StartSessionMonitoring extends SessionEvent {
  final String sessionId;

  const StartSessionMonitoring({
    required this.sessionId,
  });

  @override
  List<Object> get props => [sessionId];
}
