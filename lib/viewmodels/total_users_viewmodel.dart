import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repository/total_user_repository.dart';


class TotalUsersViewModel extends ChangeNotifier {
  final TotalUserRepository _totaluserRepository = TotalUserRepository();

  List<UserModel> _users = [];
  int _userCount = 0;
  bool _isLoading = true;

  List<UserModel> get users => _users;
  int get userCount => _userCount;
  bool get isLoading => _isLoading;

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    _users = await _totaluserRepository.fetchAllUsers();
    _userCount = _users.length;

    _isLoading = false;
    notifyListeners();
  }
}
