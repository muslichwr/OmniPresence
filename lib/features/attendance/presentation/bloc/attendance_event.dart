part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object> get props => [];
}

class SubmitAttendanceEvent extends AttendanceEvent {
  final String sessionCode;

  const SubmitAttendanceEvent({
    required this.sessionCode,
  });

  @override
  List<Object> get props => [sessionCode];
}

class ValidateSessionCodeEvent extends AttendanceEvent {
  final String code;

  const ValidateSessionCodeEvent({
    required this.code,
  });

  @override
  List<Object> get props => [code];
}
