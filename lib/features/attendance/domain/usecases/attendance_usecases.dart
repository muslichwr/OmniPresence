import 'package:school_attendance/features/attendance/data/repositories/attendance_repository.dart';
import 'package:school_attendance/models/attendance_record_model.dart';
import 'package:school_attendance/models/attendance_session_model.dart';

class CreateSessionUseCase {
  final AttendanceRepository repository;

  CreateSessionUseCase(this.repository);

  Future<AttendanceSessionModel> execute(
      String subjectId, int durationMinutes) {
    return repository.createSession(subjectId, durationMinutes);
  }
}

class GetActiveSessionsUseCase {
  final AttendanceRepository repository;

  GetActiveSessionsUseCase(this.repository);

  Future<List<AttendanceSessionModel>> execute(String teacherId) {
    return repository.getActiveSessions(teacherId);
  }
}

class ExpireSessionUseCase {
  final AttendanceRepository repository;

  ExpireSessionUseCase(this.repository);

  Future<void> execute(String sessionId) {
    return repository.expireSession(sessionId);
  }
}

class SubmitAttendanceUseCase {
  final AttendanceRepository repository;

  SubmitAttendanceUseCase(this.repository);

  Future<AttendanceRecordModel> execute(String sessionCode) {
    return repository.submitAttendance(sessionCode);
  }
}

class ValidateSessionCodeUseCase {
  final AttendanceRepository repository;

  ValidateSessionCodeUseCase(this.repository);

  Future<bool> execute(String code) {
    return repository.validateSessionCode(code);
  }
}

class GetSessionByCodeUseCase {
  final AttendanceRepository repository;

  GetSessionByCodeUseCase(this.repository);

  Future<AttendanceSessionModel?> execute(String code) {
    return repository.getSessionByCode(code);
  }
}

class GetSessionAttendanceUseCase {
  final AttendanceRepository repository;

  GetSessionAttendanceUseCase(this.repository);

  Future<List<AttendanceRecordModel>> execute(String sessionId) {
    return repository.getSessionAttendance(sessionId);
  }
}

class StreamSessionAttendanceUseCase {
  final AttendanceRepository repository;

  StreamSessionAttendanceUseCase(this.repository);

  Stream<List<AttendanceRecordModel>> execute(String sessionId) {
    return repository.streamSessionAttendance(sessionId);
  }
}
