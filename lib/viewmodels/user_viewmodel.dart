import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repository = UserRepository();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  // Fetch user from Firebase
  Future<void> fetchUser(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _repository.getUser(userId);
    } catch (e) {
      print("Error fetching user: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a new user
  Future<void> addUser(UserModel user) async {
    try {
      await _repository.addUser(user);
    } catch (e) {
      print("Error adding user: $e");
    }
  }

  // Update user
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _repository.updateUser(userId, updates);
      fetchUser(userId); // Refresh data
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _repository.deleteUser(userId);
      _user = null;
      notifyListeners();
    } catch (e) {
      print("Error deleting user: $e");
    }
  }
}
