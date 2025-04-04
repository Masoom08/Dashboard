import 'package:dashboard/views/dashboard/sidebar.dart';
import 'package:dashboard/theme/colors.dart';
import 'package:flutter/material.dart';

class AnnouncementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(), // Assuming Sidebar is already implemented
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Message To All Users",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: "Title",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: "Write Paragraph Here!",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle send action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                            ),
                            child: const Text("Send", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
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

// Integrate this into your Dashboard
void navigateToAnnouncement(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AnnouncementScreen()),
  );
}
