import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String baseUrl = "http://192.168.1.10:5000/api/auth";

  /// Normal login with phone + password
  Future<Map<String, dynamic>> login(String phone, String password) async {
    final url = Uri.parse("$baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phone, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data.containsKey("token")) {
        return data; // ✅ Success
      } else {
        return {"error": data["error"] ?? "Unknown error"};
      }
    } catch (e) {
      return {"error": "Network error: ${e.toString()}"};
    }
  }

  /// Signup/Login with Firebase OTP
  Future<Map<String, dynamic>> signupOrLoginWithFirebase({
    required String phone,
    required String idToken,
  }) async {
    final url = Uri.parse("$baseUrl/signup");

    try {
      if (phone.isEmpty || idToken.isEmpty) {
        return {"error": "Phone or ID token cannot be empty"};
      }

      print("📤 Sending to backend: { phone: $phone, idToken: $idToken }");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": phone,
          "idToken": idToken,
        }),
      );

      print("📥 Backend response (${response.statusCode}): ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data.containsKey("token")) {
        return data; // ✅ Success
      } else {
        return {"error": data["error"] ?? "Backend did not return a token"};
      }
    } catch (e) {
      return {"error": "Network/parsing error: ${e.toString()}"};
    }
  }
}
