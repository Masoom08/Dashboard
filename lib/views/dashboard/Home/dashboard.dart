import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../Annoucement.dart';
import 'consultant.dart';
import 'earnings.dart';
import 'overview.dart';
import '../sidebar.dart';
import 'total_user.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 1;

  void onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          selectedIndex == 3 ? "Announcements" : "Dashboard",
          style: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
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
          Sidebar(
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
          Expanded(
            child: selectedIndex == 3
                ? AnnouncementScreen()
                : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                child: ConsultantRequests(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: OverviewGraph(),
                              ),
                              SizedBox(width: isSmallScreen ? 8 : 16),
                              Expanded(
                                flex: 1,
                                child: TotalUsersCard(),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: const Text(
                            "Users Demographics",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildBarRow("India", 0.65),
                              _buildBarRow("Canada", 0.22),
                              _buildBarRow("Australia", 0.14),
                              _buildBarRow("United Kingdom", 0.03),
                              _buildBarRow("United States", 0.08),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarRow(String country, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 130, child: Text(country)),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
              minHeight: 16,
            ),
          ),
          const SizedBox(width: 12),
          Text("${(value * 100).round()}%"),
        ],
      ),
    );
  }
}
