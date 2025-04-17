import 'package:flutter/material.dart';

class ResetPasswordNew extends StatelessWidget {
  const ResetPasswordNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Please check your email for a password reset link.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
