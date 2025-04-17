import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repository = UserRepository();

  List<UserModel> _allUsers = [];
  List<UserModel> get allUsers => _allUsers;


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
      // Attempt to login the user via repository
      final loggedInUser = await _repository.loginUser(email, password);

      // If login successful, assign the logged-in user to _user
      if (loggedInUser != null) {
        _user = loggedInUser;
        print('✅ Login successful for user: ${_user!.email}');
        return true;
      } else {
        // If credentials are invalid, set an error message
        _errorMessage = "Invalid email or password";
        print('❌ Login failed: Invalid credentials for $email');
        return false;
      }
    } catch (e) {
      // Handle any exceptions (e.g., network errors) that may occur
      _errorMessage = e.toString();
      print('🔴 Exception during login: $e');
      return false;
    } finally {
      // Always reset the loading state and notify listeners
      _isLoading = false;
      notifyListeners();
      print('ℹ️ Login process completed');
    }
  }

  // Optionally, you can add a method to handle logout
  Future<void> logout() async {
    _user = null;  // Clear user data
    notifyListeners();  // Notify UI to update
    print('ℹ️ User logged out');
  }

  Future<void> fetchAllUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final users = await _repository.fetchAllUsers();
      _allUsers = users;
      _errorMessage = null;
      print('✅ Fetched ${users.length} users');
    } catch (e) {
      _errorMessage = e.toString();
      print('🔴 Error fetching users: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}