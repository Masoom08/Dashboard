import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../sidebar.dart'; // ✅ Import Sidebar

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int selectedIndex = 2; // ✅ Message Icon Should be Selected

  final List<Map<String, String>> feedbacks = [
    {
      "name": "Georgy Luchkin",
      "message":
      "Lorem ipsum dolor sit amet consectetur. Id sollicitudin elit vitae ac massa est cursus. "
          "In nisl sit ullamcorper nunc. Leo arcu dolor amet praesent ornare. Nunc vel sagittis velit "
          "dui sed elementum. Libero quis sed eget pellentesque massa arcu amet. Ipsum vestibulum "
          "cum arcu ultrices bibendum. Habitant amet viverra porttitor ultrices sed donec volutpat "
          "fusce sed. Aliquam nullam arcu quam sagittis aliquam non vitae condimentum. Tempus nunc ac "
          "donec sapien malesuada. Faucibus mattis amet vulputate iaculis felis nibh. Eu sed quis iaculis "
          "tortor malesuada in. Eget turpis enim malesuada pulvinar nisi augue tristique gravida. Eu "
          "tincidunt suscipit donec odio. Praesent dictum mattis quam mauris a sed mattis nulla.",
      "date": "20/2/2025"
    },
    // Add more dummy feedback items if needed
  ];

  void showFeedbackDialog(String name, String message, String date) {
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
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              Text(
                                name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                date,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.close, color: Colors.grey[700]),
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
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(
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
                      itemCount: feedbacks.length,
                      itemBuilder: (context, index) {
                        final feedback = feedbacks[index];
                        return GestureDetector(
                          onTap: () {
                            showFeedbackDialog(
                              feedback['name']!,
                              feedback['message']!,
                              feedback['date']!,
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primaryBlue,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              title: Text(feedback['name']!),
                              subtitle: Text(
                                feedback['message']!.length > 50
                                    ? feedback['message']!.substring(0, 50) + '...'
                                    : feedback['message']!,
                              ),
                              trailing: Text(feedback['date']!),
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
