import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: AppColors.primaryBlue,
      child: Column(
        children: [
          SizedBox(height: 20), // Add spacing from top
          IconButton(icon: const Icon(Icons.volunteer_activism, color: Colors.white), onPressed: () {},),
          SizedBox(height: 20),
          Icon(Icons.dashboard, color: Colors.white, size: 32),
          SizedBox(height: 20),
          Icon(Icons.message, color: Colors.white, size: 32),
          SizedBox(height: 20),
          IconButton(icon: const Icon(Icons.campaign, color: Colors.white), onPressed: () {},),
          Spacer(),
          Icon(Icons.logout, color: Colors.white, size: 32),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
