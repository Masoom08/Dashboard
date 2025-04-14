import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../viewmodels/feedback_viewmodel.dart';
import 'sidebar.dart'; // ✅ Import Sidebar
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
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
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$userName",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                          Text(
                            "${timestamp.day}/${timestamp.month}/${timestamp.year}",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: viewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Users Feedback",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              title: Text("User: $userName"),
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
          ),
        ],
      ),
    );
  }
}
