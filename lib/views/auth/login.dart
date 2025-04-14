import 'package:dashboard/theme/colors.dart';
import 'package:dashboard/views/auth/reset_password_email.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/user_viewmodel.dart';
import '../dashboard/Home/Dashboard/dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginVM = Provider.of<UserViewModel>(context);
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                controller: emailController,
                                validator: (val) =>
                                val == null || val.isEmpty ? 'Enter email' : null,
                                decoration: InputDecoration(
                                  labelText: 'Your email',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: passwordController,
                                obscureText:  !_isPasswordVisible,
                                validator: (val) =>
                                val == null || val.isEmpty ? 'Enter password' : null,
                                decoration: InputDecoration(
                                  labelText: 'Enter your password',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const ResetPasswordEmail()),
                                    );
                                  },
                                  child: const Text('Forgot Password?'),
                                ),
                              ),
                              if (loginVM.errorMessage != null)
                                Text(
                                  loginVM.errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: loginVM.isLoading
                                      ? null
                                      : () async {
                                    if (_formKey.currentState!.validate()) {
                                      bool success = await loginVM.login(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );
                                      if (success && context.mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => const DashboardScreen()),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryBlue,
                                  ),
                                  child: loginVM.isLoading
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text('Login',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (screenWidth > 800)
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
                              width: screenWidth * 0.35,
                              height: screenHeight * 0.5,
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
                              width: screenWidth * 0.15,
                              height: screenHeight * 0.15,
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
