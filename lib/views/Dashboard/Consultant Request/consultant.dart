import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Add this import for caching network images
import '../../../../../models/doctor.dart';
import '../../../../../theme/colors.dart';
import '../../../../../viewmodels/doctor_viewmodel.dart';
import 'doctor/DoctorVerificationDialog.dart';
import 'doctor/consultant_full_screen.dart';

class ConsultantRequests extends StatelessWidget {
  final bool showAll;
  ConsultantRequests({this.showAll = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 500;

        return Consumer<DoctorViewModel>(
          builder: (context, viewModel, _) {
            final doctors = viewModel.serviceAgreedDoctors; // Use the filtered list directly
            if (doctors.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(child: Text(viewModel.errorMessage.isNotEmpty ? viewModel.errorMessage : 'No doctors found')),
              );
            }

            // Determine which doctors to display based on the 'showAll' flag
            final List<Doctor> displayedDoctors = showAll ? doctors : doctors.take(2).toList();

            return Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Consultant Requests",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            if (!showAll)
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ConsultantRequestsScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Full Screen",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: Text("Doctors"),
                        ),
                      ],
                    ),
                  ),

                  // Doctor List
                  ...displayedDoctors.map((doctor) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Picture
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryBlue,
                            ),
                            child: doctor.profilePicUrl.isNotEmpty
                                ? CachedNetworkImage(
                              imageUrl: doctor.profilePicUrl,
                              imageBuilder: (context, imageProvider) {
                                return CircleAvatar(backgroundImage: imageProvider);
                              },
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Center(
                                  child: Text(
                                    doctor.name.isNotEmpty ? doctor.name[0] : '',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  )),
                            )
                                : Center(
                              child: Text(
                                doctor.name.isNotEmpty ? doctor.name[0] : '',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doctor.name,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                Text(doctor.profession,
                                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          if (!isSmallScreen)
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => DoctorVerificationDialog(doctor: doctor),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              child: Text("Check form"),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
