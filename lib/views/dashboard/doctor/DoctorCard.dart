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
          radius: 25,
          backgroundColor: Colors.grey[200],
          child: doctor.profilePicUrl.isNotEmpty
              ? ClipOval(
            child: Image.network(
              doctor.profilePicUrl,
              fit: BoxFit.cover, // Ensures the image fits within the circle
              width: 50, // Circle size
              height: 50, // Circle size
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.person, color: Colors.grey[700]);
              },
            ),
          )
              : Icon(Icons.person, color: Colors.grey[700]),
        ),
        title: Text(
          doctor.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${doctor.profession} Doctor"),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DoctorVerificationDialog(doctor: doctor);
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Check form",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
