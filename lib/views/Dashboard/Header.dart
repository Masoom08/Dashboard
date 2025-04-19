import 'package:flutter/material.dart';
 // <-- Update to your correct path
import '../../../../theme/colors.dart';
import '../../models/user.dart';
import 'CompleteAdminProfileScreen.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CompleteAdminProfileScreen(), // <- Use your actual screen
                ),
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryBlue,
              backgroundImage: (currentUser?.profilePicUrl != null && currentUser!.profilePicUrl!.isNotEmpty)
                  ? NetworkImage(currentUser!.profilePicUrl!)
                  : null,
              child: (currentUser?.profilePicUrl == null || currentUser!.profilePicUrl!.isEmpty)
                  ? const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
