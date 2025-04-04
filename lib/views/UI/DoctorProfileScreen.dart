import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/doctor_viewmodel.dart';

class DoctorProfileScreen extends StatelessWidget {
  final String userId;

  const DoctorProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doctorViewModel = Provider.of<DoctorViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Doctor Profile")),
      body: Center(
        child: doctorViewModel.isLoading
            ? CircularProgressIndicator()
            : doctorViewModel.doctor != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage:
              NetworkImage(doctorViewModel.doctor!.profilePicUrl),
              radius: 50,
            ),
            SizedBox(height: 10),
            Text("Name: ${doctorViewModel.doctor!.name}"),
            Text("Profession: ${doctorViewModel.doctor!.profession}"),
            Text("Experience: ${doctorViewModel.doctor!.experience} years"),
            Text("State: ${doctorViewModel.doctor!.state}"),
          ],
        )
            : Text("Doctor not found"),
      ),
    );
  }
}
