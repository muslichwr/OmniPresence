import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_attendance/features/attendance/domain/usecases/attendance_usecases.dart';
import 'package:school_attendance/models/attendance_record_model.dart';
import 'package:school_attendance/models/attendance_session_model.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final CreateSessionUseCase createSessionUseCase;
  final GetActiveSessionsUseCase getActiveSessionsUseCase;
  final ExpireSessionUseCase expireSessionUseCase;
  final GetSessionAttendanceUseCase getSessionAttendanceUseCase;
  final StreamSessionAttendanceUseCase streamSessionAttendanceUseCase;

  SessionBloc({
    required this.createSessionUseCase,
    required this.getActiveSessionsUseCase,
    required this.expireSessionUseCase,
    required this.getSessionAttendanceUseCase,
    required this.streamSessionAttendanceUseCase,
  }) : super(SessionInitial()) {
    on<CreateSession>(_onCreateSession);
    on<LoadActiveSessions>(_onLoadActiveSessions);
    on<EndSession>(_onEndSession);
    on<StartSessionMonitoring>(_onStartSessionMonitoring);
  }

  Future<void> _onCreateSession(
      CreateSession event, Emitter<SessionState> emit) async {
    emit(SessionLoading());

    try {
      final session = await createSessionUseCase.execute(
        event.subjectId,
        event.durationMinutes,
      );

      emit(SessionCreated(session: session));
    } catch (e) {
      emit(SessionError(message: e.toString()));
    }
  }

  Future<void> _onLoadActiveSessions(
      LoadActiveSessions event, Emitter<SessionState> emit) async {
    emit(SessionLoading());

    try {
      final sessions = await getActiveSessionsUseCase.execute(event.teacherId);
      emit(ActiveSessionsLoaded(sessions: sessions));
    } catch (e) {
      emit(SessionError(message: e.toString()));
    }
  }

  Future<void> _onEndSession(
      EndSession event, Emitter<SessionState> emit) async {
    emit(SessionLoading());

    try {
      await expireSessionUseCase.execute(event.sessionId);
      emit(SessionEnded());
    } catch (e) {
      emit(SessionError(message: e.toString()));
    }
  }

  Future<void> _onStartSessionMonitoring(
      StartSessionMonitoring event, Emitter<SessionState> emit) async {
    try {
      // Get initial session data
      final records =
          await getSessionAttendanceUseCase.execute(event.sessionId);

      // For now, we'll create a mock session - in real implementation,
      // you'd fetch the actual session data
      final session = AttendanceSessionModel(
        id: event.sessionId,
        sessionCode: '123456',
        subjectId: 'subject1',
        sessionDate: DateTime.now(),
        sessionTimeStart: DateTime.now(),
        sessionTimeEnd: DateTime.now().add(const Duration(hours: 1)),
        codeExpiresAt: DateTime.now().add(const Duration(minutes: 15)),
        status: SessionStatus.active,
        createdBy: 'teacher1',
        createdAt: DateTime.now(),
      );

      emit(SessionMonitoring(
        session: session,
        attendanceRecords: records,
      ));

      // Start listening to real-time updates
      await emit.forEach(
        streamSessionAttendanceUseCase.execute(event.sessionId),
        onData: (records) => SessionMonitoring(
          session: session,
          attendanceRecords: records,
        ),
        onError: (error, stackTrace) => SessionError(message: error.toString()),
      );
    } catch (e) {
      emit(SessionError(message: e.toString()));
    }
  }
}
