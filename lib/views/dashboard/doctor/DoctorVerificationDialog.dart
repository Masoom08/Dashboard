import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class DoctorVerificationDialog extends StatefulWidget {
  @override
  _DoctorVerificationDialogState createState() => _DoctorVerificationDialogState();
}

class _DoctorVerificationDialogState extends State<DoctorVerificationDialog> {
  Map<String, String> statusMap = {};

  void updateStatus(String key, String status) {
    setState(() {
      statusMap[key] = status;
    });
  }

  Widget buildStatusButton(String key) {
    if (statusMap.containsKey(key)) {
      return Text(
        statusMap[key]!,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: statusMap[key] == "Accepted" ? AppColors.Green : AppColors.Red,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.Red),
          onPressed: () => updateStatus(key, "Declined"),
          child: Text("Decline", style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.Green),
          onPressed: () => updateStatus(key, "Accepted"),
          child: Text("Accept", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: AppColors.softWhite,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: AppColors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/doctor_placeholder.png'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Georgy Luchkin", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black)),
                    Text("(Orthopedics)", style: TextStyle(fontSize: 14, color: AppColors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.blueTint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Education Qualification", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                        SizedBox(height: 5),
                        Text("Degree: Bachelor in Design", style: TextStyle(color: AppColors.grey)),
                        Text("College: IIT Bombay", style: TextStyle(color: AppColors.grey)),
                        Text("Year: 2022", style: TextStyle(color: AppColors.grey)),
                        SizedBox(height: 10),
                        buildStatusButton("education"),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.blueTint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Medical Registration", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                        SizedBox(height: 5),
                        Text("Reg. Number: 234343232321312", style: TextStyle(color: AppColors.grey)),
                        Text("Council: UP Medical Council", style: TextStyle(color: AppColors.grey)),
                        Text("Year: 2022", style: TextStyle(color: AppColors.grey)),
                        SizedBox(height: 10),
                        buildStatusButton("registration"),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Identity Proof", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black)),
                        SizedBox(height: 5),
                        Container(
                          height: 80,
                          color: AppColors.blueTint,
                        ),
                        SizedBox(height: 10),
                        buildStatusButton("identity"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.LightGreen,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () {},
                child: Text("Accept Applicant", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
