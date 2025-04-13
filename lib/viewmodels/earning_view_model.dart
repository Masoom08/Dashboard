import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../services/wallet_service.dart';
import '../utils/date_filter_util.dart';

enum EarningFilter { today, thisWeek, thisMonth, halfYear, thisYear }

class EarningsViewModel extends ChangeNotifier {
  final WalletService _walletService;

  double _earnings = 0;
  double get earnings => _earnings;  // This is the equivalent of totalEarnings

  EarningFilter _currentFilter = EarningFilter.today;
  EarningFilter get currentFilter => _currentFilter;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  EarningsViewModel({WalletService? walletService})
      : _walletService = walletService ?? WalletService();

  // Set the filter and re-fetch earnings based on the selected filter
  void setFilter(EarningFilter filter) {
    _currentFilter = filter;
    fetchAndCalculateEarnings();
  }

  // General method to fetch wallets and calculate earnings
  Future<void> fetchAndCalculateEarnings() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch all wallets from the service
      final List<Wallet> wallets = await _walletService.fetchAllWallets();

      // Filter wallets based on the selected date range
      final filteredWallets = wallets.where((wallet) {
        switch (_currentFilter) {
          case EarningFilter.today:
            return DateFilterUtil.isInToday(wallet.walletCreatedAt);
          case EarningFilter.thisWeek:
            return DateFilterUtil.isInThisWeek(wallet.walletCreatedAt);
          case EarningFilter.thisMonth:
            return DateFilterUtil.isInThisMonth(wallet.walletCreatedAt);
          case EarningFilter.halfYear:
            return DateFilterUtil.isInHalfYear(wallet.walletCreatedAt);
          case EarningFilter.thisYear:
            return DateFilterUtil.isInThisYear(wallet.walletCreatedAt);
          default:
            return false;
        }
      }).toList();

      // Calculate earnings as 5% of wallet balances
      _earnings = filteredWallets.fold(0.0, (sum, wallet) {
        return sum + (wallet.balance * 0.05); // 5% of each wallet balance
      });
    } catch (e) {
      // Handle errors here if necessary
      _earnings = 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch earnings for Today
  Future<void> fetchEarningsForToday() async {
    _currentFilter = EarningFilter.today;
    await fetchAndCalculateEarnings();
  }

  // Fetch earnings for This Week
  Future<void> fetchEarningsForThisWeek() async {
    _currentFilter = EarningFilter.thisWeek;
    await fetchAndCalculateEarnings();
  }

  // Fetch earnings for This Month
  Future<void> fetchEarningsForMonth(int month, int year) async {
    _currentFilter = EarningFilter.thisMonth;
    await fetchAndCalculateEarnings();
  }

  // Fetch earnings for This Year
  Future<void> fetchEarningsForYear(int year) async {
    _currentFilter = EarningFilter.thisYear;
    await fetchAndCalculateEarnings();
  }

  // Fetch earnings for a specific date
  Future<void> fetchEarningsForDate(DateTime date) async {
    // You can modify this method to handle any specific date filtering
    _currentFilter = EarningFilter.today; // As an example, we can default it to today
    await fetchAndCalculateEarnings();
  }
}
