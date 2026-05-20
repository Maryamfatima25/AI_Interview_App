import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/applicant_model.dart';
import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/applicants/applicant_dashboard_screen.dart';
import 'screens/recruiter/dashboard_screen.dart';
import 'data/applicant_store.dart';
import 'data/job_store.dart';
import 'services/applicant_profile_cache.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3949AB)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1A237E),
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F4FF),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3949AB),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      // ── Auto-login returning users ─────────────────────
      home: const SplashRouter(),
    );
  }
}

// Checks if user already logged in → routes correctly
class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});

  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    // Load local demo persistence (SharedPreferences) before routing.
    await Future.wait([loadApplicantsFromFile(), loadJobsFromFile()]);

    final user = await AuthService.getLoggedInUser();

    if (!mounted) return;

    if (user == null) {
      // Not logged in → show login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    // Already logged in → route by role
    if (user['role'] == 'recruiter') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      final uid = user['uid'] as String?;
      if (uid != null) {
        await ApplicantProfileCache.loadIntoCurrentApplicant(uid);
        if (currentApplicant.email.isEmpty &&
            (user['email'] as String?)?.isNotEmpty == true) {
          currentApplicant.email = user['email'] as String;
        }
        if (currentApplicant.name.isEmpty &&
            (user['name'] as String?)?.isNotEmpty == true) {
          currentApplicant.name = user['name'] as String;
        }
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ApplicantDashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Splash screen while checking login
    return const Scaffold(
      backgroundColor: Color(0xFFF0F4FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_history_rounded,
              size: 64,
              color: Color(0xFF3949AB),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Color(0xFF3949AB), strokeWidth: 2),
            SizedBox(height: 16),
            Text(
              'AI Interview App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
