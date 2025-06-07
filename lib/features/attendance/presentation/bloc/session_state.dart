part of 'session_bloc.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class SessionCreated extends SessionState {
  final AttendanceSessionModel session;

  const SessionCreated({
    required this.session,
  });

  @override
  List<Object> get props => [session];
}

class ActiveSessionsLoaded extends SessionState {
  final List<AttendanceSessionModel> sessions;

  const ActiveSessionsLoaded({
    required this.sessions,
  });

  @override
  List<Object> get props => [sessions];
}

class SessionEnded extends SessionState {}

class SessionMonitoring extends SessionState {
  final AttendanceSessionModel session;
  final List<AttendanceRecordModel> attendanceRecords;

  const SessionMonitoring({
    required this.session,
    required this.attendanceRecords,
  });

  @override
  List<Object> get props => [session, attendanceRecords];
}

class SessionError extends SessionState {
  final String message;

  const SessionError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
