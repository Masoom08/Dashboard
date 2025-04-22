import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dashboardN/viewmodels/doctor_viewmodel.dart';
import '../../../../../../models/doctor.dart';
import '../../../../../../theme/colors.dart';
// ... all your imports remain unchanged

class DoctorVerificationDialog extends StatefulWidget {
  final Doctor doctor;

  const DoctorVerificationDialog({super.key, required this.doctor});

  @override
  State<DoctorVerificationDialog> createState() => _DoctorVerificationDialogState();
}

class _DoctorVerificationDialogState extends State<DoctorVerificationDialog> {
  static const accepted = "Accepted";
  static const declined = "Declined";

  late Map<String, String> statusMap;

  @override
  void initState() {
    super.initState();
    statusMap = {
      "education": "",
      "registration": "",
      "identity": "",
    };
  }

  void updateStatus(String key, String status) {
    setState(() {
      statusMap[key] = status;
    });
  }

  bool get isAllAccepted => statusMap.values.every((status) => status == accepted);

  Widget buildStatusButton(String key , DoctorViewModel doctorViewModel , Doctor doctor) {
    final currentStatus = statusMap[key] ?? "";

    if (currentStatus.isNotEmpty) {
      return Text(
        currentStatus,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: currentStatus == accepted ? AppColors.Green : AppColors.Red,
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.Red),
            onPressed: () async {
              updateStatus(key, declined);
              await doctorViewModel.rejectedDoctorRequest(doctor.userId);
              Navigator.pop(context);
            },
            child: const Text("Decline", style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.Green),
            onPressed: () async {
              updateStatus(key, accepted);
            },
            child: const Text("Accept", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context ) {
    final doctorViewModel = context.read<DoctorViewModel>();
    final doctor = widget.doctor;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: AppColors.softWhite,
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: AppColors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.grey,
                  backgroundImage: doctor.profilePicUrl.isNotEmpty
                      ? NetworkImage(doctor.profilePicUrl)
                      : null,
                  child: doctor.profilePicUrl.isEmpty
                      ? Text(
                    doctor.name.isNotEmpty ? doctor.name[0].toUpperCase() : "?",
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  )
                      : null,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      doctor.departments.isNotEmpty ? doctor.departments[0] : "N/A",
                      style: const TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: buildInfoCard(
                    title: "Education Qualification",
                    customContent: buildDocDetails(
                      titleLabels: const ['Degree', 'College/University', 'Year'],
                      docText: doctor.educationDoc ?? '',
                      label: "Qualification Document",
                    ),
                    key: "education",
                    color: AppColors.blueTint,
                    doctorViewModel: doctorViewModel,
                    doctor: doctor,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: buildInfoCard(
                    title: "Medical Registration",
                    customContent: buildDocDetails(
                      titleLabels: const ['Registration Number', 'Council', 'Year'],
                      docText: doctor.medicalProof ?? '',
                      label: "Registration Document",
                    ),
                    key: "registration",
                    color: AppColors.blueTint,
                    doctorViewModel: doctorViewModel,
                    doctor: doctor,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: buildInfoCard(
                    title: "Identity Proof",
                    customContent: doctor.idUrl.isNotEmpty
                        ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            child: InteractiveViewer(
                              child: Image.network(
                                doctor.idUrl,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/img.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          doctor.idUrl,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/img.png',
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                        : Image.asset(
                      'assets/img.png',
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    key: "identity",
                    color: AppColors.blueTint,
                    doctorViewModel: doctorViewModel,
                    doctor: doctor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            if (isAllAccepted)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.LightGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () async {
                  await doctorViewModel.updateServiceAgreedStatus(doctor.userId);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Accept Applicant",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildDocDetails({
    required List<String> titleLabels,
    required String docText,
    required String label,
  }) {
    final parts = docText.split(',').map((e) => e.trim()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < titleLabels.length; i++)
          Text('${titleLabels[i]}: ${parts.length > i ? parts[i] : "Not available"}'),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget buildDocumentLink(String label, String? url) {
    if (url != null && url.isNotEmpty) {
      return TextButton(
        onPressed: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            debugPrint("Could not launch $url");
          }
        },
        child: Text(
          '$label: $url',
          style: const TextStyle(color: AppColors.primaryBlue, decoration: TextDecoration.underline),
        ),
      );
    } else {
      return Text('$label: Not available', style: const TextStyle(color: AppColors.grey));
    }
  }

  Widget buildInfoCard({
    required String title,
    required Widget customContent,
    required String key,
    required Color color,
    required DoctorViewModel doctorViewModel,
    required Doctor doctor
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 10),
          customContent,
          const SizedBox(height: 10),
          buildStatusButton(key , doctorViewModel , doctor),
        ],
      ),
    );
  }
}
