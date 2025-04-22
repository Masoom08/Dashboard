import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/demographic.dart';
import '../repository/demographic_repository.dart'; // This will be your custom model for demographics

class DemographicsViewModel extends ChangeNotifier {
  final DemographicsRepository _repository = DemographicsRepository();
  List<Demographic> demographics = [];
  bool isLoading = false;

  // Fetch all users and process demographics
  Future<void> fetchDemographics() async {
    isLoading = true;
    notifyListeners();

    try {
      List<UserModel> users = await _repository.fetchAllUsers();
      print("Fetched ${users.length} users.");
      // Process state counts for demographics
      Map<String, int> stateCounts = {};

      for (var user in users) {
        String state = (user.state == null || user.state.trim().isEmpty) ? "Others" : user.state;
        print("User State: $state"); // Updated debug output
        stateCounts[state] = (stateCounts[state] ?? 0) + 1;
      }
      final sortedEntries = stateCounts.entries.toList()
        ..sort((a, b) {
          if (a.key == "Others") return 1;
          if (b.key == "Others") return -1;
          return a.key.compareTo(b.key);
        });

      demographics = sortedEntries
          .map((entry) => Demographic(place: entry.key, count: entry.value))
          .toList();
      print("Demographics: $demographics");
    } catch (e) {
      print('Error fetching demographics: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
