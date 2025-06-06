part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSubmitted extends AttendanceState {
  final String status;
  final String sessionId;
  final DateTime timestamp;
  final String subjectName;

  const AttendanceSubmitted({
    required this.status,
    required this.sessionId,
    required this.timestamp,
    required this.subjectName,
  });

  @override
  List<Object?> get props => [status, sessionId, timestamp, subjectName];
}

class SessionCodeValidated extends AttendanceState {
  final String code;

  const SessionCodeValidated({
    required this.code,
  });

  @override
  List<Object> get props => [code];
}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
