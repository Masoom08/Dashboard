import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../services/wallet_service.dart';
import '../utils/date_filter_util.dart';

enum EarningFilter { today, thisWeek, thisMonth, halfYear, thisYear }

class EarningsViewModel extends ChangeNotifier {
  final WalletService _walletService;

  final Map<String, double> _monthlyEarnings = {}; // Key: MM-yyyy, Value: total earnings
  Map<String, double> get monthlyEarnings => _monthlyEarnings;

  double _earnings = 0;
  double get earnings => _earnings;

  EarningFilter _currentFilter = EarningFilter.today;
  EarningFilter get currentFilter => _currentFilter;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  EarningsViewModel({WalletService? walletService})
      : _walletService = walletService ?? WalletService();

  void setFilter(EarningFilter filter) {
    _currentFilter = filter;
    fetchAndCalculateEarnings();
  }

  Future<void> fetchAndCalculateEarnings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<Wallet> wallets = await _walletService.fetchAllWallets();

      _monthlyEarnings.clear();

      for (var wallet in wallets) {
        final createdAt = wallet.walletCreatedAt;
        final key = "${createdAt.month.toString().padLeft(2, '0')}-${createdAt.year}"; // MM-yyyy

        _monthlyEarnings.update(
          key,
              (value) => value + (wallet.balance * 0.05),
          ifAbsent: () => wallet.balance * 0.05,
        );
      }

      // Set total _earnings for current filter
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

      _earnings = filteredWallets.fold(0.0, (sum, wallet) => sum + (wallet.balance * 0.05));
    } catch (e) {
      _earnings = 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> fetchEarningsForToday() async {
    _currentFilter = EarningFilter.today;
    await fetchAndCalculateEarnings();
  }

  Future<void> fetchEarningsForThisWeek() async {
    _currentFilter = EarningFilter.thisWeek;
    await fetchAndCalculateEarnings();
  }

  Future<void> fetchEarningsForMonth(int month, int year) async {
    _currentFilter = EarningFilter.thisMonth;
    await fetchAndCalculateEarnings();
  }

  Future<void> fetchEarningsForYear(int year) async {
    _currentFilter = EarningFilter.thisYear;
    await fetchAndCalculateEarnings();
  }

  Future<void> fetchEarningsForDate(DateTime date) async {
    _currentFilter = EarningFilter.today;
    await fetchAndCalculateEarnings();
  }

  /// ✅ Add this method to support custom date range filtering
  Future<void> fetchEarningsBetweenDates(DateTime start, DateTime end) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Ensure correct date order
      if (start.isAfter(end)) {
        final temp = start;
        start = end;
        end = temp;
      }

      final wallets = await _walletService.fetchAllWallets();

      final filtered = wallets.where((wallet) =>
      wallet.walletCreatedAt.isAfter(start.subtract(const Duration(days: 1))) &&
          wallet.walletCreatedAt.isBefore(end.add(const Duration(days: 1)))
      ).toList();

      _earnings = filtered.fold(0.0, (sum, wallet) => sum + (wallet.balance * 0.05));
    } catch (e) {
      _earnings = 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
