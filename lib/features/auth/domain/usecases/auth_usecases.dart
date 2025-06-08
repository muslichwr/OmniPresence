import 'package:school_attendance/features/auth/data/repositories/auth_repository.dart';
import 'package:school_attendance/models/user_model.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserModel> execute(String email, String password) {
    return repository.login(email, password);
  }
}

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> execute() {
    return repository.logout();
  }
}

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserModel> execute({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? studentId,
    String? classId,
    String? phone,
  }) {
    return repository.register(
      email: email,
      password: password,
      name: name,
      role: role,
      studentId: studentId,
      classId: classId,
      phone: phone,
    );
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<UserModel?> execute() {
    return repository.getCurrentUser();
  }
}

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> execute(String email) {
    return repository.resetPassword(email);
  }
}
