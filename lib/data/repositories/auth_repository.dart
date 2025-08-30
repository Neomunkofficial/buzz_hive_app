import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String _baseUrl = "http://localhost:3000/api"; // replace with backend url

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Save token in secure storage later
      return true;
    } else {
      return false;
    }
  }
}
