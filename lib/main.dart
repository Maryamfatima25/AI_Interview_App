import 'package:ai_interview_app/screens/applicants/applicant_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Interview App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ApplicantDashboardScreen(),
    );
  }
}