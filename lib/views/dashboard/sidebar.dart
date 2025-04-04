import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'Annoucement.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int selectedIndex = -1; // Track selected index (-1 means none selected)

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: AppColors.primaryBlue,
      child: Column(
        children: [
          SizedBox(height: 20),
          buildIconButton(Icons.volunteer_activism, 0),
          SizedBox(height: 20),
          buildIconButton(Icons.dashboard, 1),
          SizedBox(height: 20),
          buildIconButton(Icons.message, 2),
          SizedBox(height: 20),
          buildIconButton(Icons.campaign, 3, onPressed: () {
            navigateToAnnouncement(context);
          }),
          Spacer(),
          buildIconButton(Icons.logout, 4),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildIconButton(IconData icon, int index, {VoidCallback? onPressed}) {
    return IconButton(
      icon: Icon(
        icon,
        color: selectedIndex == index ? Colors.white : Colors.white60, // Change color on selection
      ),
      iconSize: 32,
      onPressed: () {
        setState(() {
          selectedIndex = index;
        });
        if (onPressed != null) onPressed();
      },
    );
  }
}
