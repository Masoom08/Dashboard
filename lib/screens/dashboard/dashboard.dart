import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'consultant.dart';
import 'earnings.dart';
import 'overview.dart';
import 'sidebar.dart';
import 'total_user.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
                "https://randomuser.me/api/portraits/men/1.jpg",
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
              //padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isSmallScreen = constraints.maxWidth < 700;
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 240,
                                  child: EarningsCard(),
                                ),
                              ),
                              SizedBox(width: isSmallScreen ? 8 : 16),
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  child: ConsultantRequests(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  //height: 280,
                                  child: OverviewGraph(),
                                ),
                              ),
                              SizedBox(width: isSmallScreen ? 8 : 16),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  //height: 280,
                                  child: TotalUsersCard(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
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
