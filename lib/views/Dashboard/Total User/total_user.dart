import 'package:dashboardN/models/user.dart';
import 'package:dashboardN/views/Dashboard/Total%20User/total_user_full.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../models/doctor.dart';
import '../../../../../theme/colors.dart';
import '../../../../../viewmodels/doctor_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../viewmodels/user_viewmodel.dart'; // Import for cached images

class TotalUsersCard extends StatefulWidget {
  @override
  _TotalUsersCardState createState() => _TotalUsersCardState();
}

class _TotalUsersCardState extends State<TotalUsersCard> {
  bool _showMore = false;
  bool _isShowingDoctors  = false;

  @override
  Widget build(BuildContext context) {
    final doctorViewModel = Provider.of<DoctorViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context);
    final users = userViewModel.allUsers; // Assuming this fetches all users

    final doctors = doctorViewModel.serviceAgreedDoctors; // Use serviceAgreedDoctors
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
                    Text("Pending Doctors : ${doctorViewModel.serviceAgreedDoctors.length}", style: _whiteTextStyle), // Updated text
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
                  children: _isShowingDoctors
                      ? _getFilteredDoctors(doctorViewModel)
                      .take(2)
                      .map((doc) => _buildDoctorTile(doc))
                      .toList()
                      : users
                      .take(2)
                      .map((user) => _buildUserTile(user))
                      .toList(),
                ),

              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildUserTile(UserModel user) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 6),
      leading: user.profilePicUrl != null && user.profilePicUrl!.isNotEmpty
          ? CircleAvatar(
        backgroundImage: NetworkImage(user.profilePicUrl!),
        radius: 24,
      )
          : CircleAvatar(
        backgroundColor: AppColors.primaryBlue,
        radius: 24,
        child: Text(
          user.name.isNotEmpty ? user.name[0] : '',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      title: Text(user.name),
      subtitle: Text(user.email ?? ""),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18),
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isShowingDoctors = false;
                });
              },
              child: Text("Clients"),
              style: _filterBtnStyle.copyWith(
                backgroundColor: MaterialStateProperty.all(!_isShowingDoctors ? Colors.white : Colors.grey[300]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isShowingDoctors = true;
                });
              },
              child: Text("Consultants"),
              style: _filterBtnStyle.copyWith(
                backgroundColor: MaterialStateProperty.all(_isShowingDoctors ? Colors.white : Colors.grey[300]),
              ),
            ),
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
            ElevatedButton(onPressed: () {
              setState(() {
              _isShowingDoctors = false;
            });
              }, child: Text("Clients"), style: _filterBtnStyle),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () {
              setState(() {
                _isShowingDoctors = true;
              });
            }, child: Text("Consultants"), style: _filterBtnStyle),
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
    final pendingDoctors = doctorViewModel.approvedDoctors;
    final category = doctorViewModel.selectedCategory;

    if (category.isEmpty) return pendingDoctors;

    return pendingDoctors
        .where((doctor) => doctor.departments.contains(category))
        .toList();
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

  // Builds individual doctor tile with image fallback
  Widget _buildDoctorTile(Doctor doctor) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 6),
      leading: doctor.profilePicUrl.isNotEmpty
          ? CachedNetworkImage(
        imageUrl: doctor.profilePicUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => CircleAvatar(
          backgroundColor: AppColors.primaryBlue,
          radius: 24,
          child: Text(
            doctor.name.isNotEmpty ? doctor.name[0] : '',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      )
          : CircleAvatar(
        backgroundColor: AppColors.primaryBlue,
        radius: 24,
        child: Text(
          doctor.name.isNotEmpty ? doctor.name[0] : '',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
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
