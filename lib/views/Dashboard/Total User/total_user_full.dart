import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../models/doctor.dart';
import '../../../../../theme/colors.dart';
import '../../../../../viewmodels/doctor_viewmodel.dart';
import '../../../models/user.dart';
import '../Header.dart';
import '../sidebar.dart';
import 'package:cached_network_image/cached_network_image.dart';

const List<String> earningOptions = [
  "Today Earning",
  "This week Earning",
  "This month Earning",
  "6 month Earning",
  "This year Earning",
  "Custom"
];

class TotalUserScreen extends StatefulWidget {
  final UserModel? currentUser; // Accept currentUser as a parameter

  const TotalUserScreen({Key? key, this.currentUser}) : super(key: key);

  @override
  State<TotalUserScreen> createState() => _TotalUserScreenState();
}

class _TotalUserScreenState extends State<TotalUserScreen> {
  String selectedEarningType = "Today Earning"; // Initial value

  final List<String> initialDepartments = [
    "All Doctors",
    "Orthopedics",
    "Dentists",
    "Cardiologists",
    "Neurologists",
  ];

  final List<String> extraDepartments = [
    "Ayurveda",
    "Unani",
    "Veterinary",
    "General Physician",
  ];

  bool showMoreDepartments = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _paragraphController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => DoctorViewModel()..fetchDoctors(),
      child: Scaffold(
        drawer: Sidebar(
          selectedIndex: 1,
          onItemSelected: (int index) {},
        ),
        body: Consumer<DoctorViewModel>(
          builder: (context, viewModel, _) {
            final doctors = viewModel.selectedCategory.isEmpty
                ? viewModel.approvedDoctors
                : viewModel.getFilteredDoctors(viewModel.selectedCategory);

            return Row(
              children: [
                Sidebar(
                  selectedIndex: 0,
                  onItemSelected: (int index) {},
                ),
                Expanded(
                  child: Column(
                    children: [
                      CustomHeader(
                        title: "Users",
                        currentUser: widget.currentUser,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth > 600 ? 16 : 8),
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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        backgroundColor: Colors.transparent,
        child: Container(
          width: 300,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Green glowing circle with check icon
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            colors: [
                              Color(0xCCB2FF59),
                              Color(0xFF00E676),
                            ],
                            radius: 0.85,
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Letter Sended",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              // Close button inside the box
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Colors.black, size: 24),
                ),
              ),
            ],
          ),
        ),
      ),
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
    List<String> displayedDepartments = List.from(initialDepartments);

    if (showMoreDepartments) {
      displayedDepartments.addAll(extraDepartments);
    }

    displayedDepartments.add(showMoreDepartments ? "Show less" : "Show more");

    return Wrap(
      spacing: 8,
      children: displayedDepartments.map((dept) {
        if (dept == "Show more" || dept == "Show less") {
          return ActionChip(
            label: Text(dept),
            onPressed: () {
              setState(() {
                showMoreDepartments = !showMoreDepartments;
              });
            },
          );
        }
        if (dept == "All Doctors") {
          return ChoiceChip(
            label: Text(dept),
            selected: viewModel.selectedCategory == "",
            onSelected: (_) => viewModel.setCategory(""),
          );
        }
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
        //_buildStatCard("Orthopedics", "500"),
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
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
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
                        child: Text(value, style: const TextStyle(fontSize: 13)),
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
              // Debugging: Check if balance is being passed and isn't 0
              print("Doctor: ${doc.name}, Balance: ${doc.balance}");

              return DataRow(
                cells: [
                  DataCell(Row(
                    children: [
                      doc.profilePicUrl.isNotEmpty
                          ? CachedNetworkImage(
                        imageUrl: doc.profilePicUrl,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                          radius: 24,
                        ),
                        placeholder: (context, url) => const SizedBox(
                          height: 48,
                          width: 48,
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: AppColors.primaryBlue,
                          radius: 20,
                          child: Text(
                            doc.name.isNotEmpty ? doc.name[0].toUpperCase() : '',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      )
                          : CircleAvatar(
                        backgroundColor: AppColors.primaryBlue,
                        radius: 24,
                        child: Text(
                          doc.name.isNotEmpty ? doc.name[0].toUpperCase() : '',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${doc.name} Doctor"),
                          Text(
                            "(${doc.profession})",
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  )),
                  DataCell(Text(doc.balance.toString() != '0' ? doc.balance.toString() : 'N/A')), // Show 'N/A' if balance is 0
                  DataCell(Text((doc.balance != 0 ? (doc.balance * 0.05).toString() : '0'))), // Show '0' if balance is 0
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
                            builder: (_) => Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Are you sure you want to block this user?'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // Implement block functionality
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Yes'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('No'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Block',
                          child: Text('Block'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Warn',
                          child: Text('Warn'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'View Documents',
                          child: Text('View Documents'),
                        ),
                      ],
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

}
