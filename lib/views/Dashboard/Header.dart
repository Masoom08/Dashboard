import 'package:flutter/material.dart';
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
    final String name = currentUser?.name ?? '';
    final String? profilePicUrl = currentUser?.profilePicUrl;
    debugPrint("Profile URL : $profilePicUrl");
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
          if (name.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(
                name,
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
                  builder: (_) => CompleteAdminProfileScreen(),
                ),
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryBlue,
              backgroundImage: (profilePicUrl != null && profilePicUrl.isNotEmpty)
                  ? NetworkImage(profilePicUrl)
                  : null,
              child: (profilePicUrl == null || profilePicUrl.isEmpty)
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
