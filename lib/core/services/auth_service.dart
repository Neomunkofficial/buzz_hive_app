import '../network/api_client.dart';

class AuthService {
  final ApiClient apiClient = ApiClient();

  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String phone,
  }) async {
    return await apiClient.post("auth/signup", {
      "email": email,
      "password": password,
      "phone_number": phone,
    });
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await apiClient.post("auth/login", {
      "email": email,
      "password": password,
    });
  }
}
