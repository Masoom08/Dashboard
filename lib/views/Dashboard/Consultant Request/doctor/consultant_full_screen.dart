import 'package:cached_network_image/cached_network_image.dart';
import 'package:dashboardN/views/Dashboard/Consultant%20Request/doctor/DoctorVerificationDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../models/doctor.dart';
import '../../../../../../theme/colors.dart';
import '../../../../../../viewmodels/doctor_viewmodel.dart';
import '../../../../models/user.dart';
import '../../Header.dart';
import '../../sidebar.dart';
import 'pagination_controls.dart';


class ConsultantRequestsScreen extends StatelessWidget {
  final UserModel? currentUser; // Accept currentUser as a parameter

  const ConsultantRequestsScreen({Key? key, this.currentUser}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorViewModel(),
      child: Scaffold(
        body: Row(
          children: [
            Sidebar(
              selectedIndex: 0,
              onItemSelected: (index) {
                // Add screen navigation logic here if needed
              },
            ),
            const Expanded(child: ConsultantRequestsList()),
          ],
        ),
      ),
    );
  }
}

class ConsultantRequestsList extends StatelessWidget {
  final UserModel? currentUser;

  const ConsultantRequestsList({Key? key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doctorVM = Provider.of<DoctorViewModel>(context);

    // Handle pagination for serviceAgreedDoctors
    final startIndex = (doctorVM.currentPage - 1) * 10;
    final endIndex = (startIndex + 10 > doctorVM.serviceAgreedDoctors.length)
        ? doctorVM.serviceAgreedDoctors.length
        : startIndex + 10;
    final paginatedDoctors = doctorVM.serviceAgreedDoctors.sublist(startIndex, endIndex);

    return Column(
      children: [
        CustomHeader(
          title: "Consultant Requests",
          currentUser: currentUser,
        ),
        /*
        const Padding(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Consultant Requests",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),

         */
        Expanded(
          child: doctorVM.isLoading
              ? const Center(child: CircularProgressIndicator())
              : doctorVM.serviceAgreedDoctors.isNotEmpty
              ? ListView.builder(
            itemCount: paginatedDoctors.length,
            itemBuilder: (context, index) {
              return DoctorCard(doctor: paginatedDoctors[index]);
            },
          )
              : const Center(child: Text("No consultant requests.")),
        ),
        PaginationControls(
          currentPage: doctorVM.currentPage,
          totalPages: doctorVM.totalPages,
          onPrevious: doctorVM.previousPage,
          onNext: doctorVM.nextPage,
        ),
      ],
    );
  }
}

// 👇 DoctorCard Widget with image fallback built-in
class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    String initials = '';
    if (doctor.name.isNotEmpty) {
      final parts = doctor.name.trim().split(' ');
      initials = parts.map((e) => e[0]).take(2).join().toUpperCase();
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryBlue,
          ),
          child: doctor.profilePicUrl.isNotEmpty
              ? CachedNetworkImage(
            imageUrl: doctor.profilePicUrl,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Center(
              child: Text(
                initials,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          )
              : Center(
            child: Text(
              initials,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
        title: Text(doctor.name),
        subtitle: Text(doctor.profession),
        trailing: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => DoctorVerificationDialog(doctor: doctor),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text("Check form"),
        ),
      ),
    );
  }
}
