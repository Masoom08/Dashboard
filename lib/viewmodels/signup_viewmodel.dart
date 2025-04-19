import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'AdminProfileViewModel.dart';
 // Import the AdminProfileViewModel

class SignupViewModel with ChangeNotifier {
  final AuthService _authService;

  SignupViewModel(this._authService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get errorMessage => _error;

  Future<bool> signUp(String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      await _authService.signUp(email, password);
      return true;
    } catch (e) {
      _error = _handleFirebaseError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginUser(String email, String password, BuildContext context) async {
    _setLoading(true);
    _error = null;

    try {
      // Login via AuthService
      await _authService.login(email, password, context);

      // Load the admin profile after login
      final adminProfileVM = Provider.of<AdminProfileViewModel>(context, listen: false);
      await adminProfileVM.loadAdminProfile();

      return true;
    } catch (e) {
      _error = _handleFirebaseError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _handleFirebaseError(Object e) {
    final error = e.toString();
    if (error.contains('email-already-in-use')) {
      return "Email is already in use.";
    } else if (error.contains('user-not-found')) {
      return "User not found. Please sign up.";
    } else if (error.contains('wrong-password')) {
      return "Incorrect password.";
    } else if (error.contains('weak-password')) {
      return "Password is too weak.";
    } else if (error.contains('invalid-email')) {
      return "Invalid email address.";
    } else {
      return "Unexpected error: $error";
    }
  }
}
