import 'package:flutter/material.dart';
import '../../viewmodels/user_viewmodel.dart';

/*
class UserProfileScreen extends StatelessWidget {
  final String userId;

  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body: Center(
        child: userViewModel.isLoading
            ? CircularProgressIndicator()
            : userViewModel.user != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage:
              NetworkImage(userViewModel.user!.profilePicUrl),
              radius: 50,
            ),
            SizedBox(height: 10),
            Text("Name: ${userViewModel.user!.name}"),
            Text("Email: ${userViewModel.user!.email}"),
            Text("Phone: ${userViewModel.user!.phone}"),
            Text("Age: ${userViewModel.user!.age}"),
            Text("Gender: ${userViewModel.user!.gender}"),
          ],
        )
            : Text("User not found"),
      ),
    );
  }
}

 */
