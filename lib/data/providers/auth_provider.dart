import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login(String email, String password) async {
    try {
      _isLoggedIn = (await _authRepository.login(email, password)) as bool;
      notifyListeners();
      return _isLoggedIn;
    } catch (e) {
      debugPrint("Login failed: $e");
      return false;
    }
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
