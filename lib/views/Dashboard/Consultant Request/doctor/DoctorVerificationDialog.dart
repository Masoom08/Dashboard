import 'package:flutter/material.dart';

import 'package:dashboardN/viewmodels/doctor_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../models/doctor.dart';
import '../../../../../../theme/colors.dart';


class DoctorVerificationDialog extends StatefulWidget {
  final Doctor doctor;

  DoctorVerificationDialog({required this.doctor});

  @override
  _DoctorVerificationDialogState createState() =>
      _DoctorVerificationDialogState();
}

class _DoctorVerificationDialogState extends State<DoctorVerificationDialog> {
  Map<String, String> statusMap = {};

  void updateStatus(String key, String status) {
    setState(() {
      statusMap[key] = status;
    });
  }

  bool get isAllAccepted =>
      statusMap["education"] == "Accepted" &&
          statusMap["registration"] == "Accepted" &&
          statusMap["identity"] == "Accepted";

  Widget buildStatusButton(String key) {
    if (statusMap.containsKey(key)) {
      return Text(
        statusMap[key]!,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: statusMap[key] == "Accepted"
              ? AppColors.Green
              : AppColors.Red,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.Red),
            onPressed: () => updateStatus(key, "Declined"),
            child: Text("Decline", style: TextStyle(color: Colors.white)),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.Green),
            onPressed: () => updateStatus(key, "Accepted"),
            child: Text("Accept", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctorViewModel = Provider.of<DoctorViewModel>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: AppColors.softWhite,
      insetPadding: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.black),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            // Doctor Info
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(widget.doctor.profilePicUrl),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.doctor.name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black)),
                    Text("(${widget.doctor.profession})",
                        style: TextStyle(fontSize: 14, color: AppColors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // Three Sections
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: buildInfoCard(
                    title: "Education Qualification",
                    info: [/*
                      "Degree: Bachelor in Design",
                      "College: IIT Bombay",
                      "Year: 2022",*/
                      //'Qualification Doc: ${widget.doctor.educationDoc.isNotEmpty ? widget.doctor.educationDoc : 'Not available'}',
                    ],
                    customContent: buildQualificationDoc(
                      '${widget.doctor.educationDoc.isNotEmpty ? widget.doctor.educationDoc : 'Not available'}',
                      widget.doctor.educationDocUrl,
                    ),

                    key: "education",
                    color: AppColors.blueTint,

                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: buildInfoCard(
                    title: "Medical Registration",
                    info: [/*
                      "Reg. Number: 234343232321312",
                      "Council: UP Medical Council",
                      "Year: 2022"*/
                    ],
                    customContent: buildMedicalRegistration(
                      '${widget.doctor.medicalProof.isNotEmpty ? widget.doctor.medicalProof : 'Not available'}',
                      widget.doctor.medicalProofUrl,
                    ),
                    key: "registration",
                    color: AppColors.blueTint,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: buildImageCard(
                    title: "Identity Proof",
                    key: "identity",
                    imagePath:  widget.doctor.idUrl,//'assets/img.png',
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),

            // Show only if all sections accepted
            if (isAllAccepted)
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.LightGreen,
                    padding:
                    EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: () async {
                    await doctorViewModel.updateServiceAgreedStatus(widget.doctor.userId);
                    Navigator.pop(context);
                  },
                  child: Text("Accept Applicant",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildQualificationDoc(String docText, String docUrl) {
    // Split the input text into parts using commas
    final parts = docText.split(',').map((e) => e.trim()).toList();

    // Ensure we have exactly 3 parts for Degree, College, and Year
    final degree = parts.length > 0 ? parts[0] : 'Not available';
    final college = parts.length > 1 ? parts[1] : 'Not available';
    final year = parts.length > 2 ? parts[2] : 'Not available';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text('Degree: $degree'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text('College: $college'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text('Year: $year'),
        ),
        SizedBox(height: 10),
        // Add the document URL if it's available
        docUrl.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: GestureDetector(
            onTap: () async{
              final uri = Uri.parse(docUrl);
              if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
              // Optionally show an error snackbar or alert
              debugPrint('Could not launch $docUrl');
              }
            },
            child: Text(
              'Qualification Document: $docUrl',
              style: TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.w500),
            ),
          ),
        )
            : Text(
          'Qualification Document: Not available',
          style: TextStyle(color: AppColors.grey),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget buildMedicalRegistration(String docText, String docUrl) {
    // Split the input text into parts using commas
    final parts = docText.split(',').map((e) => e.trim()).toList();

    // Ensure we have exactly 3 parts for Degree, College, and Year
    final number = parts.length > 0 ? parts[0] : 'Not available';
    final council = parts.length > 1 ? parts[1] : 'Not available';
    final year = parts.length > 2 ? parts[2] : 'Not available';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text('Registration Number: $number'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text('Registration Council: $council'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text('Registration Year(YYYY): $year'),
        ),
        SizedBox(height: 10),
        // Add the document URL if it's available
        docUrl.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: GestureDetector(
            onTap: () async{
              final uri = Uri.parse(docUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                // Optionally show an error snackbar or alert
                debugPrint('Could not launch $docUrl');
              }
            },
            child: Text(
              'Qualification Document: $docUrl',
              style: TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.w500),
            ),
          ),
        )
            : Text(
          'Qualification Document: Not available',
          style: TextStyle(color: AppColors.grey),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget buildInfoCard({
    required String title,
    required List<String> info,
    Widget? customContent,
    required String key,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black)),
          SizedBox(height: 5),
          ...info.map(
                  (line) => Text(line, style: TextStyle(color: AppColors.grey))),
          SizedBox(height: 10),
          if (customContent != null) customContent,
          buildStatusButton(key),
        ],
      ),
    );
  }

  Widget buildImageCard({
    required String title,
    required String key,
    required String imagePath,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black)),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  backgroundColor: Colors.black,
                  insetPadding: EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4,
                        child: Image.asset(imagePath, fit: BoxFit.contain),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 80,
                width: double.infinity,
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(height: 10),
          buildStatusButton(key),
        ],
      ),
    );
  }
}
