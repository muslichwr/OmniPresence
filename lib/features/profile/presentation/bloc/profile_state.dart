part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdating extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final String? className;

  const ProfileLoaded({
    required this.user,
    this.className,
  });

  @override
  List<Object?> get props => [user, className];
}

class ProfileUpdateSuccess extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
