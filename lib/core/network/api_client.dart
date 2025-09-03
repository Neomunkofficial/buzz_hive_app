// lib/core/network/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = "http://10.0.2.2:3000/api";
  // ⚠️ use 10.0.2.2 for Android emulator, replace with your system IP on real device
  static String? _authToken;

  /// Save auth token after login
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Clear auth token on logout
  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> _headers() {
    final headers = {"Content-Type": "application/json"};
    if (_authToken != null) {
      headers["Authorization"] = "Bearer $_authToken";
    }
    return headers;
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
      body: jsonEncode(data),
    );

    return _processResponse(response, "POST", endpoint);
  }

  Future<Map<String, dynamic>> patch(String endpoint, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
      body: jsonEncode(data),
    );

    return _processResponse(response, "PATCH", endpoint);
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
    );

    return _processResponse(response, "GET", endpoint);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
    );

    return _processResponse(response, "DELETE", endpoint);
  }

  Map<String, dynamic> _processResponse(http.Response response, String method, String endpoint) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception("$method $endpoint failed: ${response.statusCode} → ${response.body}");
    }
  }
}
