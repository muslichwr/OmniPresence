import 'package:school_attendance/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:school_attendance/models/subject_model.dart';

class GetStudentDashboardUseCase {
  final DashboardRepository repository;

  GetStudentDashboardUseCase(this.repository);

  Future<StudentDashboardData> execute(String studentId) {
    return repository.getStudentDashboardData(studentId);
  }
}

class GetTeacherDashboardUseCase {
  final DashboardRepository repository;

  GetTeacherDashboardUseCase(this.repository);

  Future<TeacherDashboardData> execute(String teacherId) {
    return repository.getTeacherDashboardData(teacherId);
  }
}

class GetAdminDashboardUseCase {
  final DashboardRepository repository;

  GetAdminDashboardUseCase(this.repository);

  Future<AdminDashboardData> execute() {
    return repository.getAdminDashboardData();
  }
}

class GetTodayScheduleUseCase {
  final DashboardRepository repository;

  GetTodayScheduleUseCase(this.repository);

  Future<List<SubjectModel>> execute(String userId) {
    // This would be implemented based on user role
    throw UnimplementedError('GetTodayScheduleUseCase not implemented');
  }
}
