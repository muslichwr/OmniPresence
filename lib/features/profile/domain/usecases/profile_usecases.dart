import 'package:school_attendance/features/profile/data/repositories/profile_repository.dart';
import 'package:school_attendance/models/user_model.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<UserModel> execute(String userId) {
    return repository.getUserProfile(userId);
  }
}

class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<UserModel> execute(
    String userId, {
    String? name,
    String? phone,
    String? classId,
  }) {
    return repository.updateUserProfile(
      userId,
      name: name,
      phone: phone,
      classId: classId,
    );
  }
}
