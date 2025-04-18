import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/colors.dart';
import '../../viewmodels/signup_viewmodel.dart';
import '../auth/reset_password_email.dart';
import '../Dashboard/Home_dashboard.dart';
import '../auth/signup_view.dart';

class ResetPasswordNew extends StatelessWidget {
  const ResetPasswordNew({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: LayoutBuilder(
        builder: (_, constraints) {
          return Row(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    margin: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.email_outlined, size: 48, color: Colors.blueAccent),
                        const SizedBox(height: 16),
                        const Text(
                          'Check Your Email',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'We’ve sent you a password reset link. Please check your inbox and follow the instructions to reset your password.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (screenWidth > 800) // Show images only on larger screens
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        top: screenHeight * 0.05,
                        right: screenWidth * 0.05,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            'assets/img_1.png',
                            width: screenWidth * 0.25,
                            height: screenHeight * 0.7,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.65,
                        right: screenWidth * 0.02,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/img_2.png',
                            width: screenWidth * 0.15,
                            height: screenHeight * 0.15,
                            fit: BoxFit.cover,
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
    );
  }
}
