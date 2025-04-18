import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../services/wallet_service.dart';
import '../utils/date_filter_util.dart';

enum EarningFilter { today, thisWeek, thisMonth, halfYear, thisYear }

class EarningsViewModel extends ChangeNotifier {
  final WalletService _walletService;

  final Map<String, double> _monthlyEarnings = {};
  Map<String, double> get monthlyEarnings => _monthlyEarnings;

  double _earnings = 0;
  double get earnings => _earnings;

  EarningFilter _currentFilter = EarningFilter.today;
  EarningFilter get currentFilter => _currentFilter;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DateTime? _specificDate;
  int? _month;
  int? _year;

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
        final key = "${createdAt.month.toString().padLeft(2, '0')}-${createdAt.year}";

        _monthlyEarnings.update(
          key,
              (value) => value + (wallet.balance * 0.05),
          ifAbsent: () => wallet.balance * 0.05,
        );
      }

      final filteredWallets = wallets.where((wallet) {
        final createdAt = wallet.walletCreatedAt;

        if (_specificDate != null) {
          return createdAt.year == _specificDate!.year &&
              createdAt.month == _specificDate!.month &&
              createdAt.day == _specificDate!.day;
        }

        if (_month != null && _year != null) {
          return createdAt.month == _month && createdAt.year == _year;
        }

        if (_year != null && _month == null) {
          return createdAt.year == _year;
        }

        switch (_currentFilter) {
          case EarningFilter.today:
            return DateFilterUtil.isInToday(createdAt);
          case EarningFilter.thisWeek:
            return DateFilterUtil.isInThisWeek(createdAt);
          case EarningFilter.thisMonth:
            return DateFilterUtil.isInThisMonth(createdAt);
          case EarningFilter.halfYear:
            return DateFilterUtil.isInHalfYear(createdAt);
          case EarningFilter.thisYear:
            return DateFilterUtil.isInThisYear(createdAt);
        }
      }).toList();

      _earnings = filteredWallets.fold(0.0, (sum, wallet) => sum + (wallet.balance * 0.05));
    } catch (e) {
      _earnings = 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();

      // Clear temporary filters after use
      _specificDate = null;
      _month = null;
      _year = null;
    }
  }

  Future<void> fetchEarningsForToday() async {
    _currentFilter = EarningFilter.today;
    _specificDate = DateTime.now();
    await fetchAndCalculateEarnings();
  }

  Future<void> fetchEarningsForThisWeek() async {
    _currentFilter = EarningFilter.thisWeek;
    await fetchAndCalculateEarnings();
  }

  Future<void> fetchEarningsForMonth(int month, int year) async {
    _currentFilter = EarningFilter.thisMonth;
    _month = month;
    _year = year;
    await fetchAndCalculateEarnings();
  }

  Future<void> fetchEarningsForYear(int year) async {
    _currentFilter = EarningFilter.thisYear;
    _year = year;
    await fetchAndCalculateEarnings();
  }

  Future<void> fetchEarningsForDate(DateTime date) async {
    _currentFilter = EarningFilter.today;
    _specificDate = date;
    await fetchAndCalculateEarnings();
  }

  Future<void> fetchEarningsBetweenDates(DateTime start, DateTime end) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (start.isAfter(end)) {
        final temp = start;
        start = end;
        end = temp;
      }

      final earnings = await _walletService.calculateEarningsBetweenDates(
        startDate: start,
        endDate: end,
      );

      _earnings = earnings;
    } catch (e) {
      _earnings = 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
