import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'data/applicant_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ← required before async

  await loadApplicantsFromFile(); // ← loads saved applicants before app opens

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Interview App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // Start from login screen
      home: const LoginScreen(),
    );
  }
}