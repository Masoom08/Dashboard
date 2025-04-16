import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../theme/colors.dart';
import '../../viewmodels/feedback_viewmodel.dart';
import 'Header.dart';
import 'sidebar.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  final UserModel? currentUser; // ✅ Accept currentUser

  const FeedbackScreen({Key? key, this.currentUser}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    Provider.of<FeedbackViewModel>(context, listen: false).fetchFeedbacks();
  }

  void showFeedbackDialog(String userName, String message, DateTime timestamp) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            width: 700,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primaryBlue,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          timestamp.toLocal().toString(),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FeedbackViewModel>(context);
    //final feedbacks = feedbackViewModel.feedbackWithUsers;

    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Column(
              children: [
                // ✅ Custom Header at the top
                CustomHeader(
                  title: "Feedbacks",
                  currentUser: widget.currentUser,
                ),
                const SizedBox(height: 20),
                // Feedback list
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.feedbackWithUsers.length,
                    itemBuilder: (context, index) {
                      final feedbackWithUser = viewModel.feedbackWithUsers[index];
                      final feedback = feedbackWithUser.feedback;
                      final userName = feedbackWithUser.userName;

                      return GestureDetector(
                        onTap: () {
                          showFeedbackDialog(
                            userName,
                            feedback.message,
                            feedback.timestamp,
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primaryBlue,
                              radius: 24,
                              child: Text(
                                userName.isNotEmpty ? userName[0].toUpperCase() : '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            title: Text("$userName"),
                            subtitle: Text(
                              feedback.message.length > 50
                                  ? feedback.message.substring(0, 50) + '...'
                                  : feedback.message,
                            ),
                            trailing: Text(
                              "${feedback.timestamp.day}/${feedback.timestamp.month}/${feedback.timestamp.year}",
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
