// your imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/doctor.dart';
import '../../../theme/colors.dart';
import '../../../viewmodels/doctor_viewmodel.dart';
import '../sidebar.dart';

class TotalUserScreen extends StatelessWidget {
  final List<String> departments = [
    "Orthopedics",
    "Dentists",
    "Cardiologists",
    "Neurologists",
    "Show more"
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorViewModel()..fetchDoctors(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Users",
            style: TextStyle(color: Colors.black),
          ),
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
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Consumer<DoctorViewModel>(
          builder: (context, viewModel, _) {
            final doctors = viewModel.selectedCategory.isEmpty
                ? viewModel.doctors
                : viewModel.getFilteredDoctors(viewModel.selectedCategory);

            return Row(
              children: [
                Sidebar(
                  selectedIndex: 1,
                  onItemSelected: (int index) {
                    // Handle navigation
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopTabRow(viewModel),
                        const SizedBox(height: 16),
                        _buildDepartmentChips(viewModel),
                        const SizedBox(height: 16),
                        _buildStatsAndSearch(),
                        const SizedBox(height: 16),
                        viewModel.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _buildDoctorTable(context, doctors), // ✅ FIXED LINE
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopTabRow(DoctorViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        Row(
          children: [
            _buildTabButton("Doctors", true),
            _buildTabButton("Clients", false),
            _buildTabButton("Consultants", false),
          ],
        ),
      ],
    );
  }

  Widget _buildTabButton(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primaryBlue : Colors.grey[200],
        ),
        onPressed: () {},
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildDepartmentChips(DoctorViewModel viewModel) {
    return Wrap(
      spacing: 8,
      children: departments.map((dept) {
        return ChoiceChip(
          label: Text(dept),
          selected: viewModel.selectedCategory == dept,
          onSelected: (_) => viewModel.setCategory(dept),
        );
      }).toList(),
    );
  }

  Widget _buildStatsAndSearch() {
    return Row(
      children: [
        _buildStatCard("Total Users", "10,000"),
        _buildStatCard("Doctors", "1,000"),
        _buildStatCard("Orthopedics", "500"),
        const Spacer(),
        SizedBox(
          width: 300,
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              hintText: "Search by Name or Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(onPressed: () {}, child: const Text("Search")),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildDoctorTable(BuildContext context, List<Doctor> doctors) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Names")),
            DataColumn(label: Text("Today Earning")),
            DataColumn(label: Text("Company Earning")),
            DataColumn(label: Text("Emails")),
            DataColumn(label: Text("State")),
            DataColumn(label: Text("Specialization")),
          ],
          rows: doctors.map((doc) {
            return DataRow(
              cells: [
                DataCell(Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(doc.profilePicUrl),
                      radius: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(doc.name),
                  ],
                )),
                const DataCell(Text("₹200")),
                const DataCell(Text("₹50")),
                DataCell(Text(doc.email)),
                DataCell(Text(doc.state)),
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(doc.profession)),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.black),
                        color: Colors.white,
                        onSelected: (value) {
                          if (value == 'Block') {
                            showDialog(
                              context: context,
                              builder: (_) =>
                                  _buildBlockDialog(context, doc.name, doc.profession),
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return ['View Documents', 'Warn', 'Block']
                              .map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBlockDialog(BuildContext context, String name, String specialization) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Block this user $name ($specialization) Doctor for',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle 1 week block
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                ),
                child: const Text('1 WEEK',style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle permanent block
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                ),
                child: const Text('FOREVER',style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
