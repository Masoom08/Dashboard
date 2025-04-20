import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../theme/colors.dart';
import '../../viewmodels/AdminProfileViewModel.dart';
import 'Admin/AdminProfileDialog.dart';
import 'Admin/CompleteAdminProfileScreen.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final UserModel? currentUser;

  const CustomHeader({
    Key? key,
    required this.title,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProfileViewModel>(  // Listen to the profile data
        builder: (context, adminViewModel, _) {
          if (adminViewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          String imageUrl = currentUser?.profilePicUrl ?? adminViewModel.imageUrl;

          // Debug: print whether the image was fetched or not
          if (imageUrl.isNotEmpty) {
            debugPrint("Image fetched: $imageUrl");
          } else {
            debugPrint("Using default icon");
          }

          return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          if (currentUser?.name != null)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(
                currentUser!.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          GestureDetector(
            onTap: () {
              /*
              Navigator.push(
                context,
                MaterialPageRoute(
                builder: (_) =>AdminProfileDropdown(),
              ),
            );
               */
              _showProfileDropdown(context);
              },
            child: imageUrl.isNotEmpty
                ? CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(imageUrl),
            )

                : CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryBlue,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
        },
    );
  }

  // Function to show profile dropdown
  void _showProfileDropdown(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);  // Get position of avatar
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + renderBox.size.width - 30,  // Position it at the right edge
        position.dy + renderBox.size.height,  // Position it below the avatar
        0, // Right offset
        0, // No gap at the bottom
      ),
      items: [
        PopupMenuItem(
          enabled: false,
          padding: EdgeInsets.zero, // Remove default padding
          child: Container(
            color: Colors.white, // Set dropdown background here
            child: ChangeNotifierProvider(
              create: (_) => AdminProfileViewModel()
                ..fetchAdminProfile(FirebaseAuth.instance.currentUser!.uid),
              child: SizedBox(
                width: 300,
                child: Consumer<AdminProfileViewModel>(
                  builder: (context, viewModel, _) {
                    if (viewModel.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return Padding(
                      padding: const EdgeInsets.all(12), // Inner padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              viewModel.imageUrl.isNotEmpty
                                  ? CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(viewModel.imageUrl),
                              )
                                  : Icon(Icons.account_circle, size: 60),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CompleteAdminProfileScreen(),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: AppColors.black,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text('Name: ${viewModel.name}', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Email: ${viewModel.email}'),
                          Text('Phone: ${viewModel.phone}'),
                          Text('Role: ${viewModel.role}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}