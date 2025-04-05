import 'package:dashboard/views/dashboard/Home/total_user_full.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/doctor.dart';
import '../../../theme/colors.dart';
import '../../../viewmodels/doctor_viewmodel.dart';

class TotalUsersCard extends StatefulWidget {

  @override
  _TotalUsersCardState createState() => _TotalUsersCardState();
}

class _TotalUsersCardState extends State<TotalUsersCard> {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    final doctorViewModel = Provider.of<DoctorViewModel>(context);
    final doctors = doctorViewModel.doctors;
    final filteredOrthos = doctorViewModel.getFilteredDoctors("Orthopedics");
    final filteredCardios = doctorViewModel.getFilteredDoctors("Cardiology");

    final List<String> baseCategories = [
      "Doctors",
      "Orthopedics",
      "Cardiology",
      "Dentists",
    ];

    final List<String> extraCategories = [
      "Ayurveda",
      "Unani",
      "Veterinary",
      "General Physician",
    ];

    final categories =
    _showMore ? [...baseCategories, ...extraCategories] : baseCategories;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Users : 10,000",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Clients"),
                      style: _filterBtnStyle,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Consultants"),
                      style: _filterBtnStyle,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TotalUserScreen()),
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
                SizedBox(height: 8),
                Text("Doctors : ${doctors.length}",
                    style: _whiteTextStyle),
                Text("Orthopedics : ${filteredOrthos.length}",
                    style: _whiteTextStyle),
                Text("Cardiology : ${filteredCardios.length}",
                    style: _whiteTextStyle),
                SizedBox(height: 10),

                /// Filters
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    ...categories.map((category) => _categoryButton(context, category)),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showMore = !_showMore;
                        });
                      },
                      child: Text(
                        _showMore ? "Show Less ▲" : "Show More ▼",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // List of Filtered Doctors
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: doctorViewModel.selectedCategory.isEmpty
                  ? doctors
                  .map((doc) => _buildDoctorTile(doc))
                  .toList()
                  : doctorViewModel
                  .getFilteredDoctors(doctorViewModel.selectedCategory)
                  .map((doc) => _buildDoctorTile(doc))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton _categoryButton(BuildContext context, String category) {
    final doctorViewModel = Provider.of<DoctorViewModel>(context, listen: false);
    return ElevatedButton(
      onPressed: () {
        doctorViewModel.setCategory(
            category == "Doctors" ? '' : category); // Reset if "Doctors"
      },
      style: _filterBtnStyle,
      child: Text(category),
    );
  }

  Widget _buildDoctorTile(Doctor doctor) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 6),
      leading: CircleAvatar(backgroundImage: NetworkImage(doctor.profilePicUrl)),
      title: Text(doctor.name),
      subtitle: Text("${doctor.profession} • ${doctor.state}"),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18),
    );
  }

  final ButtonStyle _filterBtnStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.primaryBlue,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  final TextStyle _whiteTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
