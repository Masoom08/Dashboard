import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';
import '../repository/wallet_repository.dart';

/*
class WalletViewModel extends ChangeNotifier {
  final WalletRepository _repository = WalletRepository();
  Wallet? _wallet;
  List<Transaction> _transactions = [];
  bool _isLoading = false;

  Wallet? get wallet => _wallet;
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  // Fetch wallet details
  Future<void> fetchWallet(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _wallet = await _repository.getUserWallet(userId);
      if (_wallet != null) {
        _transactions = await _repository.getTransactions(_wallet!.walletId);
      }
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add transaction
  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _repository.addTransaction(transaction);
      fetchWallet(transaction.walletId); // Refresh wallet data
    } catch (e) {
      print("Error: $e");
    }
  }
}

 */
