import 'package:flutter/material.dart';
import '../repository/stats_repository.dart';

class StatsViewModel extends ChangeNotifier {
  final StatsRepository _repository = StatsRepository();

  // Store the stats for users joining each month
  Map<String, int> usersJoinedCount = {};

  // Loading state
  bool isLoading = true;

  /// Fetches the number of users registered per month between the specified dates.
  Future<void> fetchUsersJoinedMonthlyStats() async {
    isLoading = true;
    notifyListeners();

    // Define the start and end dates
    final startMonth = DateTime(2024, 4); // Starting from April 2024
    final endMonth = DateTime(2025, 4);   // Ending at April 2025

    try {
      // Fetch stats from the repository
      usersJoinedCount = await _repository.fetchUserRegistrationStats(startMonth, endMonth);

      // For debugging: print the number of users in March 2025
      print("Users in April 2025: ${usersJoinedCount['04-2025'] }");
    } catch (e) {
      print("Error fetching user stats: $e");
    }

    // Set loading to false and notify UI
    isLoading = false;
    notifyListeners();
  }
}
