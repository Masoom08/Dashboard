import 'package:dashboard/auth/reset_password_email.dart';
import 'package:flutter/material.dart';

import '../screens/dashboard/dashboard.dart';
import '../theme/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //const Icon(Icons.handshake, size: 40, color: AppColors.primaryBlue),
                      Image.asset('assets/health.png',width: 60, height: 60,),
                      const SizedBox(height: 20),
                      const Text(
                        'Log in to your Account',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Your email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Enter your password',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          fillColor: Colors.grey[200],
                          filled: true,
                          suffixIcon: Icon(Icons.visibility),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ResetPasswordEmail()),
                          );
                        },
                        child: const Text('Forgot Password?'),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const DashboardScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Login', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (screenWidth > 800) // Show images only on large screens
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: screenHeight * 0.05,
                          right: screenWidth * 0.05,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                              'assets/img_1.png',
                              width: screenWidth * 0.35, // 35% of screen width
                              height: screenHeight * 0.5, // 50% of screen height
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: screenHeight * 0.45,
                          right: screenWidth * 0.02,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/img_2.png',
                              width: screenWidth * 0.15, // 15% of screen width
                              height: screenHeight * 0.15, // 15% of screen height
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
