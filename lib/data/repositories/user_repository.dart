// data/repositories/user_repository.dart
import '../models/user_signup_dto.dart';
import '../../core/network/api_client.dart';

class UserRepository {
  final ApiClient api;
  UserRepository(this.api);

  Future<void> createUser(UserSignupDto dto) async {
    await api.post('/users', dto.toJson());
  }

  // Save step-by-step data (like onboarding wizard)
  Future<void> patchUser(Map<String, dynamic> partial) async {
    await api.patch('/users/me', partial);
  }
}
