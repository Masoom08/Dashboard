import 'package:dashboard/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../../models/doctor.dart';
import 'DoctorVerificationDialog.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(doctor.profilePicUrl),
        ),
        title: Text(doctor.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           // Text("📧 ${doctor.email}"),
            Text(" ${doctor.profession}" " " "Doctor"),
            //Text("📍 ${doctor.state}"),
            //Text("🗣️ ${doctor.languages.join(', ')}"),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DoctorVerificationDialog();
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text("Check form",
            style: TextStyle(color: Colors.white), // White text
          ),
        ),
      ),
    );
  }
}
