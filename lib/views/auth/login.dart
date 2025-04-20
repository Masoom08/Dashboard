import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/colors.dart';
import '../../viewmodels/signup_viewmodel.dart'; // Use SignupViewModel here
import '../auth/reset_password_email.dart';
import '../Dashboard/Home_dashboard.dart';
import '../auth/signup_view.dart'; // Import the SignUpView

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  void _showSnackBar(String msg, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  Future<void> _handleLogin(SignupViewModel viewModel) async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      bool success = await viewModel.loginUser(email, password , context);

      if (!mounted) return;

      if (success) {
        _showSnackBar("Login successful", color: Colors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: viewModel,
              child: const DashboardScreen(),
            ),
          ),
        );
      } else {
        _showSnackBar(viewModel.errorMessage ?? "Login failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define layout modes based on screen width
    String layoutMode = 'full';
    if (screenWidth <= 800) {
      layoutMode = 'minimize';
    }
    if (screenWidth <= 600) {
      layoutMode = 'half';
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (_, constraints) {
          return Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: SingleChildScrollView(
                    child: Consumer<SignupViewModel>(
                      builder: (_, viewModel, __) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/health.png', width: 60, height: 60),
                            const SizedBox(height: 20),
                            const Text(
                              'Log in to your Account',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    validator: (val) =>
                                    val == null || !val.contains('@') ? 'Enter valid email' : null,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_isPasswordVisible,
                                    validator: (val) =>
                                    val == null || val.length < 6 ? 'Password too short' : null,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                        ),
                                        onPressed: () => setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        }),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const ResetPasswordEmail(),
                                          ),
                                        );
                                      },
                                      child: const Text('Forgot Password?'),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: viewModel.isLoading
                                          ? null
                                          : () => _handleLogin(viewModel),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryBlue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: viewModel.isLoading
                                          ? const CircularProgressIndicator(color: Colors.white)
                                          : const Text('Login', style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (screenWidth > 600)
                Expanded(
                  child: layoutMode == 'full'
                      ? Stack(
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
                            fit: BoxFit.contain,
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
                  )
                      : layoutMode == 'minimize'
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Positioned(
                        top: screenHeight * 0.10,
                        right: screenWidth * 0.15,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            'assets/img_1.png',
                            width: screenWidth * 0.35,
                            height: screenHeight * 0.4,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      //const SizedBox(height: 20),
                      Positioned(
                        top: screenHeight * 0.50,
                        right: screenWidth * 0.10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/img_2.png',
                            width: screenWidth * 0.25,
                            height: screenHeight * 0.50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ) : const SizedBox.shrink(),
                ),
            ],
          );
        },
      ),
    );
  }
}
