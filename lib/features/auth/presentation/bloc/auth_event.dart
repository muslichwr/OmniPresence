part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class LogoutEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final UserRole role;
  final String? studentId;
  final String? classId;
  final String? phone;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    this.studentId,
    this.classId,
    this.phone,
  });

  @override
  List<Object?> get props =>
      [email, password, name, role, studentId, classId, phone];
}

class CheckAuthStatus extends AuthEvent {}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}
