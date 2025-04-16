import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({super.key});

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  String? profilePicUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfilePic();
  }

  Future<void> fetchProfilePic() async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      print("Logged-in email: $userEmail");

      if (userEmail != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data();
          print("User data: $data");

          setState(() {
            profilePicUrl = data['profile_pic_url'];
            isLoading = false;
          });
        } else {
          print("No user found with that email.");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("User email is null.");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching profile pic: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : GestureDetector(
      onTap: () {
        // Open profile screen or any desired screen
        Navigator.pushNamed(context, '/profile'); // example route
      },
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.blueAccent,
        backgroundImage: (profilePicUrl != null && profilePicUrl!.isNotEmpty)
            ? NetworkImage(profilePicUrl!)
            : null,
        child: (profilePicUrl == null || profilePicUrl!.isEmpty)
            ? const Icon(Icons.person, color: Colors.white)
            : null,
      ),
    );
  }
}
