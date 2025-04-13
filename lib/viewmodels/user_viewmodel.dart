import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repository = UserRepository();

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    print('🟡 Attempting login for email: $email');

    try {
      final loggedInUser = await _repository.loginUser(email, password);

      if (loggedInUser != null) {
        _user = loggedInUser;
        print('✅ Login successful for user: ${_user!.email}');
        return true;
      } else {
        _errorMessage = "Invalid email or password";
        print('❌ Login failed: Invalid credentials for $email');
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('🔴 Exception during login: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
      print('ℹ️ Login process completed');
    }
  }
}
