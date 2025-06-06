import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_attendance/features/auth/domain/usecases/auth_usecases.dart';
import 'package:school_attendance/models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RegisterUseCase registerUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.registerUseCase,
    required this.getCurrentUserUseCase,
    required this.resetPasswordUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<RegisterEvent>(_onRegister);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase.execute(event.email, event.password);
      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logoutUseCase.execute();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase.execute(
        email: event.email,
        password: event.password,
        name: event.name,
        role: event.role,
        studentId: event.studentId,
        classId: event.classId,
        phone: event.phone,
      );
      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await resetPasswordUseCase.execute(event.email);
      emit(PasswordResetSent());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
