import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_attendance/features/attendance/domain/usecases/attendance_usecases.dart';
import 'package:school_attendance/models/attendance_record_model.dart';
import 'package:school_attendance/models/attendance_session_model.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final SubmitAttendanceUseCase submitAttendanceUseCase;
  final ValidateSessionCodeUseCase validateSessionCodeUseCase;
  final GetSessionByCodeUseCase getSessionByCodeUseCase;

  AttendanceBloc({
    required this.submitAttendanceUseCase,
    required this.validateSessionCodeUseCase,
    required this.getSessionByCodeUseCase,
  }) : super(AttendanceInitial()) {
    on<SubmitAttendanceEvent>(_onSubmitAttendance);
    on<ValidateSessionCodeEvent>(_onValidateSessionCode);
  }

  Future<void> _onSubmitAttendance(
      SubmitAttendanceEvent event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());

    try {
      // First validate the code
      final isValid =
          await validateSessionCodeUseCase.execute(event.sessionCode);

      if (!isValid) {
        emit(const AttendanceError(
            message: 'Invalid session code. Please check and try again.'));
        return;
      }

      // Get session details for the response
      final session = await getSessionByCodeUseCase.execute(event.sessionCode);

      if (session == null) {
        emit(const AttendanceError(
            message:
                'Session not found. Please check the code and try again.'));
        return;
      }

      // Submit attendance
      final record = await submitAttendanceUseCase.execute(event.sessionCode);

      // Emit success state with relevant info
      emit(AttendanceSubmitted(
        status: record.attendanceStatus.name,
        sessionId: record.sessionId,
        timestamp: record.checkInTime ?? DateTime.now(),
        subjectName:
            session.subjectId, // In a real app, we would fetch the subject name
      ));
    } catch (e) {
      emit(AttendanceError(message: e.toString()));
    }
  }

  Future<void> _onValidateSessionCode(
      ValidateSessionCodeEvent event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());

    try {
      final isValid = await validateSessionCodeUseCase.execute(event.code);

      if (isValid) {
        emit(SessionCodeValidated(code: event.code));
      } else {
        emit(const AttendanceError(
            message: 'Invalid session code. Please check and try again.'));
      }
    } catch (e) {
      emit(AttendanceError(message: e.toString()));
    }
  }
}
