import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../models/doctor.dart';
import '../../../../../theme/colors.dart';
import '../../../../../viewmodels/doctor_viewmodel.dart';
import '../../../models/user.dart';
import '../../../viewmodels/total_users_viewmodel.dart';
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

     "General Physician", "Gastroenterologist", "General Surgeon",
    "Dentist", "Dermatologist", "Pediatrician", "Psychiatrist",
    "Gynecologist", "Ophthalmologist", "Dietitian", "Homeopath",
    "Plastic Surgeon", "Diagnostic Centre", "Practologist", "Naturopathy",
    "Pulmonologist", "Oncologist", "ENT", "Sexologist", "Nephrologist"
    "Ayurveda",
    "Unani",
    "Veterinary",
    "General Physician",
  ];

  bool showMoreDepartments = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _paragraphController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TotalUsersViewModel>(context, listen: false).loadUsers());
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final userViewModel = Provider.of<TotalUsersViewModel>(context);

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
            //_buildTabButton("Clients", false),
           // _buildTabButton("Consultants", false),
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
    final userViewModel = Provider.of<TotalUsersViewModel>(context);
    final doctorViewModel = Provider.of<DoctorViewModel>(context);
    return Row(
      children: [
        _buildStatCard("Total Users", "${userViewModel.userCount}"),
        _buildStatCard("Doctors", "${doctorViewModel.approvedDoctorsCount}"),
        //_buildStatCard("Orthopedics", "500"),
        const Spacer(),
        SizedBox(
          width: 300,
          height: 40,
          /*
          child: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              hintText: "Search by Name or Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),*/
        ),
        const SizedBox(width: 8),
        //ElevatedButton(onPressed: () {}, child: const Text("Search"),),
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
                          radius: 20,
                        ),
                        placeholder: (context, url) => const SizedBox(
                          height: 30,
                          width: 30,
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
                  DataCell(Text(doc.balance.toString() != '0' ? doc.balance.toStringAsFixed(2) : '00.00')), // Show 'N/A' if balance is 0
                  DataCell(Text((doc.balance != 0 ? (doc.balance * 0.05).toStringAsFixed(2) : '00.00'))), // Show '0' if balance is 0
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
                            builder: (_) => _buildBlockDialog(context, doc.name, doc.profession),
                          );
                        } else if (value == 'View Documents') {
                          showDialog(
                            context: context,
                            builder: (_) => _buildViewDocumentDialog(doc),
                          );
                        } else if (value == 'Warn') {
                          showDialog(
                            context: context,
                            builder: (_) => _buildWarnDialog(context),
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
                  _showBlockConfirmationDialog(
                    context,
                    name,
                    specialization,
                    "1 Week",
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue),
                child:
                const Text('1 WEEK', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showBlockConfirmationDialog(
                    context,
                    name,
                    specialization,
                    "FOREVER",
                  );
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
  void _showBlockConfirmationDialog(
      BuildContext context,
      String name,
      String specialization,
      String duration,
      ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Confirm Block",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Are you sure you want to block this user $name ($specialization) Doctor $duration?",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(color: AppColors.primaryBlue),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: AppColors.primaryBlue),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("User blocked for $duration.")),
                    );
                    // TODO: Block logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    "Sure",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }



  Widget _buildWarnDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        'Message To All Users',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _titleController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Title",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _paragraphController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Write Paragraph Here!",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final title = _titleController.text.trim();
            final paragraph = _paragraphController.text.trim();

            if (title.isNotEmpty && paragraph.isNotEmpty) {
              Navigator.of(context).pop(); // Close the warn dialog
              _showSuccessDialog(context); // Show the success dialog
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please fill both fields")),
              );
            }
          },
          child: const Text("Send"),
        ),
      ],
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