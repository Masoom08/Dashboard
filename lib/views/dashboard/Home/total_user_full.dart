import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/doctor.dart';
import '../../../theme/colors.dart';
import '../../../viewmodels/doctor_viewmodel.dart';
import '../sidebar.dart';

// ✅ Constant list moved outside to be used safely in const contexts
const List<String> earningOptions = [
  "Today Earning",
  "This week Earning",
  "This month Earning",
  "6 month Earning",
  "This year Earning",
  "Custom"
];

class TotalUserScreen extends StatefulWidget {
  @override
  State<TotalUserScreen> createState() => _TotalUserScreenState();
}

class _TotalUserScreenState extends State<TotalUserScreen> {
  String selectedEarningType = "Today Earning"; // Initial value

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
          title: const Text("Users", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/1.jpg"),
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
                  onItemSelected: (int index) {},
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
                            : _buildDoctorTable(context, doctors),
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
          backgroundColor:
          isSelected ? AppColors.primaryBlue : Colors.grey[200],
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
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Search"),
        ),
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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: DataTable(
            columnSpacing: 20,
            headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
            columns: [
              const DataColumn(label: Text("Names")),
              DataColumn(
                label: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedEarningType,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 2,
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedEarningType = newValue;
                        });
                      }
                    },
                    items: earningOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                        Text(value, style: const TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const DataColumn(label: Text("Company Earning")),
              const DataColumn(label: Text("Emails")),
              const DataColumn(label: Text("Phone No.")),
              const DataColumn(label: Text("Actions")),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${doc.name} Doctor"),
                          Text(
                            "(${doc.profession})",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  )),
                  const DataCell(Text("₹200")),
                  const DataCell(Text("₹50")),
                  DataCell(Text(doc.email)),
                  DataCell(Text(doc.phone)),
                  DataCell(
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.black),
                      color: Colors.white,
                      onSelected: (value) {
                        if (value == 'Block') {
                          showDialog(
                            context: context,
                            builder: (_) => _buildBlockDialog(
                                context, doc.name, doc.profession),
                          );
                        } else if (value == 'View Documents') {
                          showDialog(
                            context: context,
                            builder: (_) => _buildViewDocumentDialog(doc),
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
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildBlockDialog(
      BuildContext context, String name, String specialization) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Block this user $name ($specialization) Doctor for',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                    backgroundColor: AppColors.primaryBlue),
                child:
                const Text('1 WEEK', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle permanent block
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue),
                child: const Text('FOREVER',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewDocumentDialog(Doctor doc) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("User Document"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${doc.name}'s Uploaded Document"),
          const SizedBox(height: 16),
          Image.network(
            doc.profilePicUrl ?? "https://via.placeholder.com/150",
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
