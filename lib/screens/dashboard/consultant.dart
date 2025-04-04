import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class ConsultantRequests extends StatelessWidget {
  final List<String> consultantNames = ["Dr. Sharma", "Ms. Kapoor", "Mr. Verma", "Dr. Mehta"];

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
            Text("Consultant Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Text("Pending: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text("4", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.red)),
                Spacer(),
                Icon(Icons.person_add, size: 24, color: AppColors.primaryBlue),
              ],
            ),
            Divider(),
            ...consultantNames.map((name) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.account_circle, color: AppColors.grey),
                  SizedBox(width: 8),
                  Text(name, style: TextStyle(fontSize: 14)),
                  Spacer(),
                  Text("Pending", style: TextStyle(fontSize: 12, color: AppColors.red)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
