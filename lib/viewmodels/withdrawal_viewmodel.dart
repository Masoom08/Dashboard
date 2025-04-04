import 'package:flutter/material.dart';
import '../models/withdrawal.dart';
import '../repository/withdrawal_repository.dart';

class WithdrawalViewModel extends ChangeNotifier {
  final WithdrawalRepository _repository = WithdrawalRepository();
  List<Withdrawal> _withdrawals = [];
  bool _isLoading = false;

  List<Withdrawal> get withdrawals => _withdrawals;
  bool get isLoading => _isLoading;

  // Fetch doctor's withdrawal requests
  Future<void> fetchWithdrawals(String doctorId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _withdrawals = await _repository.getDoctorWithdrawals(doctorId);
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Request a new withdrawal
  Future<void> requestWithdrawal(Withdrawal withdrawal) async {
    try {
      await _repository.requestWithdrawal(withdrawal);
      fetchWithdrawals(withdrawal.doctorId); // Refresh list
    } catch (e) {
      print("Error: $e");
    }
  }
}
