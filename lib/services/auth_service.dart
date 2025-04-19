import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/AdminProfileViewModel.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up a new user
  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Login an existing user and load admin profile
  Future<void> login(String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After successful login, load admin profile
      final adminProfileVM = Provider.of<AdminProfileViewModel>(context, listen: false);
      await adminProfileVM.loadAdminProfile();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Handle Firebase authentication errors
  String _handleAuthError(FirebaseAuthException e) {
    if (e.code == 'email-already-in-use') {
      return "Email is already in use.";
    } else if (e.code == 'user-not-found') {
      return "User not found. Please sign up.";
    } else if (e.code == 'wrong-password') {
      return "Incorrect password.";
    } else if (e.code == 'invalid-email') {
      return "Invalid email address.";
    } else if (e.code == 'weak-password') {
      return "Password is too weak.";
    } else {
      return "Unexpected error: ${e.message}";
    }
  }
}
