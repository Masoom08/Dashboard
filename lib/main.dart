import 'package:dashboardN/services/auth_service.dart';
import 'package:dashboardN/viewmodels/doctor_viewmodel.dart';
import 'package:dashboardN/viewmodels/feedback_viewmodel.dart';
import 'package:dashboardN/viewmodels/signup_viewmodel.dart';
import 'package:dashboardN/viewmodels/user_viewmodel.dart';
import 'package:dashboardN/viewmodels/wallet_view_model.dart';
import 'package:dashboardN/views/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBNijYd0UDjhJ5h6hOBTffHlc8BSkiKus8",
      authDomain: "advilo-769f1.firebaseapp.com",
      projectId: "advilo-769f1",
      storageBucket: "advilo-769f1.appspot.com",
      messagingSenderId: "752989842418",
      appId: "1:752989842418:web:672537de4581268375d96b",
      measurementId: "G-MBFDZRCCLK",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DoctorViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => FeedbackViewModel()),
        ChangeNotifierProvider(create: (_) => EarningsViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewModel(AuthService())), // Fixed the missing provider here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const LoginScreen(),
    );
  }
}
