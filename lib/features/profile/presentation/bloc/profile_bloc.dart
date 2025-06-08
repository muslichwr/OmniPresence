import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_attendance/features/profile/domain/usecases/profile_usecases.dart';
import 'package:school_attendance/models/user_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  ProfileBloc({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = await getUserProfileUseCase.execute('current_user_id');
      emit(
          ProfileLoaded(user: user, className: 'Class 10A')); // Mock class name
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileUpdating());

    try {
      final user = await updateUserProfileUseCase.execute(
        'current_user_id',
        name: event.name,
        phone: event.phone,
      );

      emit(ProfileUpdateSuccess());
      emit(
          ProfileLoaded(user: user, className: 'Class 10A')); // Mock class name
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
