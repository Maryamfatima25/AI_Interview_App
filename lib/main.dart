import 'package:flutter/material.dart';
import 'package:ai_interview_app/screens/auth/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3949AB),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0F4FF),
      ),
      home: const LoginScreen(),
    );
  }
}
