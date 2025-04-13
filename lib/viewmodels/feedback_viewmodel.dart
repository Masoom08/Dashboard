import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/feedbacks.dart';

class FeedbackWithUser {
  final FeedbackModel feedback;
  final String userName;

  FeedbackWithUser({required this.feedback, required this.userName});
}


class FeedbackViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<FeedbackWithUser> _feedbackWithUsers = [];
  List<FeedbackWithUser> get feedbackWithUsers => _feedbackWithUsers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchFeedbacks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final feedbackSnapshot = await _firestore
          .collection('feedbacks')
          .orderBy('timestamp', descending: true)
          .get();

      List<FeedbackWithUser> tempList = [];

      for (var doc in feedbackSnapshot.docs) {
        final feedback = FeedbackModel.fromMap(doc.data());

        // Fetch user by userId from users collection
        final userDoc = await _firestore
            .collection('users')
            .doc(feedback.userId)
            .get();

        final userName = userDoc.exists
            ? (userDoc.data()?['name'] ?? 'Unknown User')
            : 'Unknown User';

        tempList.add(FeedbackWithUser(feedback: feedback, userName: userName));
      }

      _feedbackWithUsers = tempList;
    } catch (e) {
      print("Error fetching feedbacks: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}

