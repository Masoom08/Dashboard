import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class TotalUsersCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total Users", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Text("10,250", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Spacer(),
                Icon(Icons.people, size: 32, color: AppColors.primaryBlue),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.circle, size: 12, color: AppColors.green),
                SizedBox(width: 4),
                Text("Active: 8,500", style: TextStyle(fontSize: 14, color: AppColors.grey)),
                SizedBox(width: 16),
                Icon(Icons.circle, size: 12, color: AppColors.red),
                SizedBox(width: 4),
                Text("Inactive: 1,750", style: TextStyle(fontSize: 14, color: AppColors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
