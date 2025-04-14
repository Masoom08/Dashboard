import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../auth/login.dart';
import 'Annoucement.dart';
import 'Feedback.dart';
import 'Dashboard/dashboard.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: AppColors.primaryBlue,
      child: Column(
        children: [
          const SizedBox(height: 20),
          buildIconButton(Icons.volunteer_activism, 0, context),
          const SizedBox(height: 20),
          buildIconButton(Icons.dashboard, 1, context, screen: DashboardScreen()),
          const SizedBox(height: 20),
          buildIconButton(Icons.message_rounded, 2, context,screen: FeedbackScreen()),
          const SizedBox(height: 20),
          buildIconButton(Icons.campaign, 3, context, screen: AnnouncementScreen()),
          const Spacer(),
          buildLogoutButton(context), // ✅ Logout Button
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildIconButton(IconData icon, int index, BuildContext context, {Widget? screen}) {
    IconData finalIcon;

    // Choose icon variant for consultant (index 0) when selected
    if (index == 0) {
      // Always use filled icon and white color for consultant request
      return IconButton(
        onPressed: null, //
        icon: ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          child: Image.asset(
            'assets/icon.png',
            width: 32,
            height: 32,
          ),
        ),
        iconSize: 38,
        disabledColor: Colors.white, // Optional
      );
    }
    if (index == 1) {
      finalIcon = selectedIndex == index ? Icons.dashboard : Icons.dashboard_outlined;
    } else if (index == 2) {
      finalIcon = selectedIndex == index ? Icons.message_rounded : Icons.message_outlined;
    } else if (index == 3) {
      finalIcon = selectedIndex == index ? Icons.campaign : Icons.campaign_outlined;
    } else {
      finalIcon = icon;
    }

    return IconButton(
      icon: Icon(
        finalIcon,
        color: selectedIndex == index ? Colors.white : Colors.white60,
      ),
      iconSize: 32,
      onPressed: () {
        if (selectedIndex != index) {
          onItemSelected(index);
          if (screen != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          }
        }
      },
    );
  }


  Widget buildLogoutButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout, color: Colors.white60),
      iconSize: 32,
      onPressed: () => showLogoutDialog(context), // ✅ Show Logout Dialog
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("You want to logout?"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // ✅ Rounded Corners
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue, // ✅ Blue Background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), // ✅ Navigate to Login
                );
              },
              child: const Text("Yes", style: TextStyle(color: Colors.white)), // ✅ White Text
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primaryBlue), // ✅ Blue Outline
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              onPressed: () {
                Navigator.pop(context); // ❌ Stay on Dashboard
              },
              child: Text("No", style: TextStyle(color: AppColors.primaryBlue)), // ✅ Blue Text
            ),

          ],
        );
      },
    );
  }
}
