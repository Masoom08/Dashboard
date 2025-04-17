import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/signup_viewmodel.dart';


class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _createAccount(SignupViewModel viewModel) async {
    if (_formKey.currentState?.validate() ?? false) {
      bool success = await viewModel.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Account created successfully")),
        );
        // TODO: Navigate to dashboard or login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${viewModel.errorMessage ?? 'Signup failed'}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text("Create Account")),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: "Email"),
                        validator: (value) =>
                        value != null && value.contains('@')
                            ? null
                            : "Enter a valid email",
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Password"),
                        validator: (value) =>
                        value != null && value.length >= 6
                            ? null
                            : "Min 6 characters",
                      ),
                      SizedBox(height: 24),
                      viewModel.isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: () => _createAccount(viewModel),
                        child: Text("Create Account"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
