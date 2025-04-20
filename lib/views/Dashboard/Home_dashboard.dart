import 'package:flutter/material.dart';
import '../../../../theme/colors.dart';
import '../../models/user.dart';
import 'Annoucement.dart';
import 'Consultant Request/consultant.dart';
import 'Demographic/DemographicView.dart';
import 'Earning/earnings.dart';
import 'Header.dart';
import 'Overview Graph/overview.dart';
import 'Profile.dart';
import 'Total User/total_user.dart';
import 'Sidebar.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel? currentUser; // Accept currentUser as a parameter

  const DashboardScreen({Key? key, this.currentUser}): super(key: key);

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
      backgroundColor: AppColors.softWhite,
      body: Row(
        children: [
          Sidebar(
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Custom Header
                CustomHeader(
                  title: selectedIndex == 3 ? "Announcements" : "Dashboard",
                  currentUser: widget.currentUser,
                ),


                // Main dashboard content
                Expanded(
                  child: selectedIndex == 3
                      ? AnnouncementScreen()
                      : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            bool isSmallScreen = constraints.maxWidth < 700;

                            if (isSmallScreen) {
                              // Stack cards vertically on small screens
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 16),
                                  SizedBox(height: 240, child: EarningsCard()),
                                  const SizedBox(height: 16),
                                  ConsultantRequests(showAll: false),
                                  const SizedBox(height: 16),
                                  OverviewGraph(),
                                  const SizedBox(height: 16),
                                  TotalUsersCard(),
                                  const SizedBox(height: 16),
                                ],
                              );
                            } else {
                              // Original horizontal layout for larger screens
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
                                      const SizedBox(width: 24),
                                      Expanded(
                                        flex: 3,
                                        child: ConsultantRequests(showAll: false),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: OverviewGraph(),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        flex: 1,
                                        child: TotalUsersCard(),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        UserDemographicsSection(),
                        const SizedBox(height: 40),
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

  // Method to return the correct image for the profile
  ImageProvider _getProfileImage(String? url) {
    if (url != null && url.isNotEmpty) {
      return NetworkImage(url);
    } else {
      return const AssetImage('assets/default_profile_pic.png');
    }
  }
}
