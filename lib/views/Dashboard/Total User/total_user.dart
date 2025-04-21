import 'package:dashboardN/models/user.dart';
import 'package:dashboardN/views/Dashboard/Total%20User/total_user_full.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../models/doctor.dart';
import '../../../../../theme/colors.dart';
import '../../../../../viewmodels/doctor_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../viewmodels/total_users_viewmodel.dart';
import '../../../viewmodels/user_viewmodel.dart';
import 'doctor_search_bar.dart'; // Import for cached images

class TotalUsersCard extends StatefulWidget {
  @override
  _TotalUsersCardState createState() => _TotalUsersCardState();
}

class _TotalUsersCardState extends State<TotalUsersCard> {
  bool _showMore = false;
  bool _isShowingDoctors  = true;
  final TextEditingController _searchController = TextEditingController();
  final List<String> allDepartments = [
    "Cardiologists", "General Physician", "Gastroenterologist", "General Surgeon",
    "Dentist", "Dermatologist", "Pediatrician", "Psychiatrist", "Orthopedics",
    "Gynecologist", "Ophthalmologist", "Dietitian", "Homeopath", "Neurologist",
    "Plastic Surgeon", "Diagnostic Centre", "Practologist", "Naturopathy",
    "Pulmonologist", "Oncologist", "ENT", "Sexologist", "Nephrologist"
  ];

  String? _selectedDepartment;


  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TotalUsersViewModel>(context, listen: false).loadUsers());
  }

  @override
  Widget build(BuildContext context) {
    final doctorViewModel = Provider.of<DoctorViewModel>(context);
    final userViewModel = Provider.of<TotalUsersViewModel>(context);
    final users = userViewModel.users;
    final userCount = userViewModel.userCount;
    final isLoading = userViewModel.isLoading;


    final List<String> baseCategories = [
      "Orthopedics", "Cardiologists", "Dentists"
    ];
    final List<String> extraCategories = [
      "Ayurveda", "Unani", "Veterinary", "General Physician"
    ];
    final categories = _showMore ? [...baseCategories, ...extraCategories] : baseCategories;
    //final TextEditingController _searchController = TextEditingController();

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
                        ? _buildSmallScreenHeader(context,)
                        : _buildLargeScreenHeader(context,),
                    const SizedBox(height: 8),
                    Text("Pending Doctors : ${doctorViewModel.serviceAgreedDoctors.length}", style: _whiteTextStyle), // Updated text
                    const SizedBox(height: 10),

                    // Category Filters
                    // Category Filters
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Your logic here
                          },
                          style: _filterBtnStyle,
                          child: Text("Doctor"),
                        ),
                        ...baseCategories.map((category) => _categoryButton(context, category)),
                        _showMore
                            ? DropdownButton<String>(
                          value: _selectedDepartment,
                          hint: Text(
                            "Select Department",
                            style: TextStyle(color: Colors.white),
                          ),
                          dropdownColor: AppColors.primaryBlue,
                          iconEnabledColor: Colors.white,
                          underline: SizedBox(),
                          items: allDepartments.map((String dept) {
                            return DropdownMenuItem<String>(
                              value: dept,
                              child: Text(
                                dept,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDepartment = value;
                              Provider.of<DoctorViewModel>(context, listen: false).setCategory(value ?? '');
                            });
                          },
                        )
                            : TextButton(
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

              const SizedBox(height: 12),
              //DoctorSearchBar(searchController: _searchController),
              //const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: isLoading
                      ? List.generate(2, (index) => _buildLoadingTile())
                      : _isShowingDoctors
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
  Widget _buildLoadingTile() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 6),
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        radius: 24,
      ),
      title: Container(
        width: 100,
        height: 12,
        color: Colors.grey[300],
        margin: EdgeInsets.only(bottom: 4),
      ),
      subtitle: Container(
        width: 150,
        height: 10,
        color: Colors.grey[200],
      ),
    );
  }


  // Header for small screen
  Widget _buildSmallScreenHeader(BuildContext context) {
    final userViewModel = Provider.of<TotalUsersViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Total Users : ${userViewModel.userCount}", style: _whiteTextStyle),
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
                backgroundColor: MaterialStateProperty.all(
                    !_isShowingDoctors ? Colors.white : Colors.grey[300]),
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
                backgroundColor: MaterialStateProperty.all(
                    _isShowingDoctors ? Colors.white : Colors.grey[300]),
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
    final userViewModel = Provider.of<TotalUsersViewModel>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Total Users : ${userViewModel.userCount}", style: _whiteTextStyle),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isShowingDoctors = false;
                });
              },
              child: Text("Clients"),
              style: _filterBtnStyle,
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isShowingDoctors = true;
                });
              },
              child: Text("Consultants"),
              style: _filterBtnStyle,
            ),
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
      subtitle: Text(
        "${doctor.profession} • ${doctor.state}" +
            (doctor.departments != null && doctor.departments.isNotEmpty
                ? " • (${doctor.departments})"
                : ""),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            doctor.email ?? "", // Display email if available, else empty
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
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
