import 'package:dashboardN/views/Dashboard/Total%20User/total_user_full.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../models/doctor.dart';
import '../../../../../theme/colors.dart';
import '../../../../../viewmodels/doctor_viewmodel.dart';

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
      "Doctors", "Orthopedics", "Cardiology", "Dentists"
    ];
    final List<String> extraCategories = [
      "Ayurveda", "Unani", "Veterinary", "General Physician"
    ];
    final categories = _showMore ? [...baseCategories, ...extraCategories] : baseCategories;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmall = constraints.maxWidth < 500;

        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Responsive Top Row
                    isSmall
                        ? _buildSmallScreenHeader(context)
                        : _buildLargeScreenHeader(context),
                    const SizedBox(height: 8),
                    Text("Doctors : ${doctors.length}", style: _whiteTextStyle),
                    //Text("Orthopedics : ${filteredOrthos.length}", style: _whiteTextStyle),
                    //Text("Cardiology : ${filteredCardios.length}", style: _whiteTextStyle),
                    const SizedBox(height: 10),

                    // Category Filters
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
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: _getFilteredDoctors(doctorViewModel)
                      .take(2) // Show only 2 doctors
                      .map((doc) => _buildDoctorTile(doc))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Header for small screen
  Widget _buildSmallScreenHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Total Users : 10,000", style: _whiteTextStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(onPressed: () {}, child: Text("Clients"), style: _filterBtnStyle),
            ElevatedButton(onPressed: () {}, child: Text("Consultants"), style: _filterBtnStyle),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TotalUserScreen()),
                );
              },
              child: const Text(
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
      ],
    );
  }

  // Header for large screen
  Widget _buildLargeScreenHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Total Users : 10,000", style: _whiteTextStyle),
        Row(
          children: [
            ElevatedButton(onPressed: () {}, child: Text("Clients"), style: _filterBtnStyle),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () {}, child: Text("Consultants"), style: _filterBtnStyle),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TotalUserScreen()),
                );
              },
              child: const Text(
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
      ],
    );
  }

  // Returns the filtered list of doctors based on selected category
  List<Doctor> _getFilteredDoctors(DoctorViewModel doctorViewModel) {
    if (doctorViewModel.selectedCategory.isEmpty) {
      return doctorViewModel.doctors;
    }
    return doctorViewModel.getFilteredDoctors(doctorViewModel.selectedCategory);
  }

  // Category filter button
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

  // Builds individual doctor tile
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
