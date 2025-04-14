import 'package:dashboardN/views/Dashboard/Consultant%20Request/doctor/pagination_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../viewmodels/doctor_viewmodel.dart';
import '../../sidebar.dart';
import 'DoctorCard.dart';

class ConsultantRequestsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Consultant Requests"),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  "https://randomuser.me/api/portraits/men/1.jpg",
                ),
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            Sidebar(
              selectedIndex: 0,
              onItemSelected: (index) {
                // Add screen navigation logic here if needed
              },
            ),
            Expanded(child: ConsultantRequestsList(showAll: true)),
          ],
        ),
      ),
    );
  }
}

class ConsultantRequestsList extends StatelessWidget {
  final bool showAll;
  const ConsultantRequestsList({super.key, this.showAll = false});

  @override
  Widget build(BuildContext context) {
    final doctorVM = Provider.of<DoctorViewModel>(context);

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Doctors",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: doctorVM.isLoading
              ? const Center(child: CircularProgressIndicator())
              : doctorVM.doctors.isNotEmpty
              ? ListView.builder(
            itemCount: doctorVM.doctors.length, // Limit to 3 doctors
            itemBuilder: (context, index) {
              return DoctorCard(doctor: doctorVM.doctors[index]);
            },
          )
              : const Center(child: Text("No doctors available.")),
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
