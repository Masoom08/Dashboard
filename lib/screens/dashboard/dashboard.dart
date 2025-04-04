import 'package:dashboard/screens/dashboard/total_user.dart';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'consultant.dart';
import 'earnings.dart';
import 'overview.dart';
import 'sidebar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // White AppBar
        elevation: 0, // No shadow
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/1.jpg", // Replace with your actual profile image URL
                  ),
                ),
              ),
            ],
        ),
      backgroundColor: AppColors.softWhite,
      body: Row(
        children: [
          Sidebar(), // Sidebar Navigation
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: EarningsCard()),
                      SizedBox(width: 16),
                      Expanded(flex: 1, child: ConsultantRequests()),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(flex: 2, child: OverviewGraph()),
                      SizedBox(width: 16),
                      Expanded(flex: 1, child: TotalUsersCard()),
                    ],
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

