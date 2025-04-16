import 'package:dashboardN/views/Dashboard/sidebar.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../theme/colors.dart';
import 'Header.dart';

class AnnouncementScreen extends StatefulWidget {
  final UserModel? currentUser; // Accept currentUser as a parameter

  const AnnouncementScreen({Key? key, this.currentUser}): super(key: key);

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  int selectedIndex = 3; // Active index for Announcement

  void updateIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softWhite,

      body: Row(
        children: [
          Sidebar(
            selectedIndex: selectedIndex,
            onItemSelected: updateIndex,
          ),
          Expanded(
            child: Column(
              children: [

                CustomHeader(
                  title: selectedIndex == 3 ? "Message To All Users" : "Dashboard",
                  currentUser: widget.currentUser,
                ),

                /*Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  width: double.infinity,
                  child: const Text(
                    "Message To All Users",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),*/
                Flexible(
                  child: SingleChildScrollView(
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
                                  child: const TextField(
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
                                  height: 400,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: const TextField(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
