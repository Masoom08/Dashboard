import 'package:cloud_firestore/cloud_firestore.dart';

class StatsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user registration stats
  Future<Map<String, int>> fetchUserRegistrationStats(DateTime startMonth, DateTime endMonth) async {
    try {
      final snapshot = await _firestore.collection('users').get();

      // Initialize all months in the range
      final allMonths = <String, int>{};
      for (var dt = startMonth; dt.isBefore(endMonth.add(Duration(days: 1))); dt = DateTime(dt.year, dt.month + 1)) {
        final key = "${dt.month.toString().padLeft(2, '0')}-${dt.year}";
        allMonths[key] = 0;
      }

      // Count users per month
      for (var doc in snapshot.docs) {
        if (doc.data().containsKey('created_at') && doc['created_at'] != null) {
          DateTime createdAt;

          final rawCreatedAt = doc['created_at'];
          if (rawCreatedAt is Timestamp) {
            createdAt = rawCreatedAt.toDate();
          } else if (rawCreatedAt is String) {
            try {
              createdAt = DateTime.parse(rawCreatedAt); // Try ISO format
            } catch (e) {
              print("Invalid date format for document ${doc.id}: $rawCreatedAt");
              continue; // Skip invalid entries
            }
          } else {
            continue; // Skip if it's neither Timestamp nor parseable String
          }

          final key = "${createdAt.month.toString().padLeft(2, '0')}-${createdAt.year}";
          print("User registration $createdAt");

          if (allMonths.containsKey(key)) {
            allMonths[key] = allMonths[key]! + 1;
          }
        }

      }

      // Print out the final stats for debugging
      print("User registration stats: $allMonths");

      return allMonths;
    } catch (e) {
      throw Exception("Error fetching user registration stats: $e");
    }
  }
}
