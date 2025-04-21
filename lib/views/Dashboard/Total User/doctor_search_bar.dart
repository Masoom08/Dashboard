import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/colors.dart';
import '../../../viewmodels/doctorSearch_viewmodel.dart'; // ✅ updated ViewModel

class DoctorSearchBar extends StatelessWidget {
  final TextEditingController searchController;

  const DoctorSearchBar({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: "Search By Name or Email",
                hintStyle: TextStyle(color: Color(0xFF6E8294)),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Search Button
          TextButton(
            onPressed: () {
              Provider.of<DoctorSearchViewModel>(context, listen: false)
                  .searchDoctors(searchController.text);
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Search",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
