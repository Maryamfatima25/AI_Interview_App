import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../applicants/applicant_dashboard_screen.dart';
import '../recruiter/dashboard_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _login() async {
    final email = _emailCtrl.text.trim();
    final pass  = _passwordCtrl.text;

    if (email.isEmpty || pass.isEmpty) {
      _snack('Please fill in all fields', error: true);
      return;
    }
    if (!email.contains('@')) {
      _snack('Enter a valid email', error: true);
      return;
    }

    setState(() => _loading = true);

    final result = await AuthService.signIn(
      email:    email,
      password: pass,
    );

    setState(() => _loading = false);

    // Check for error
    if (result.containsKey('error')) {
      _snack(result['error'], error: true);
      return;
    }

    if (!mounted) return;

    // Route based on role from Firestore
    final role = result['role'] as String;

    if (role == 'recruiter') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => const DashboardScreen()),
            (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) =>
            const ApplicantDashboardScreen()),
            (route) => false,
      );
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
        error ? const Color(0xFFE53935)
            : const Color(0xFF43A047),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Logo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3949AB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                    Icons.work_history_rounded,
                    color: Colors.white,
                    size: 32),
              ),
              const SizedBox(height: 24),

              const Text('Welcome back',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E))),
              const SizedBox(height: 6),
              const Text(
                'Sign in to your account',
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7986CB)),
              ),
              const SizedBox(height: 40),

              _label('Email address'),
              const SizedBox(height: 8),
              _field(
                controller: _emailCtrl,
                hint: 'you@example.com',
                icon: Icons.email_outlined,
                keyboard: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              _label('Password'),
              const SizedBox(height: 8),
              _field(
                controller: _passwordCtrl,
                hint: 'Enter your password',
                icon: Icons.lock_outline,
                obscure: _obscure,
                suffix: IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF7986CB),
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscure = !_obscure),
                ),
              ),
              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2))
                      : const Text('Sign In',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style:
                    TextStyle(color: Color(0xFF7986CB)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                          const SignupScreen()),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Color(0xFF3949AB),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3949AB)));

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF3949AB).withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        style: const TextStyle(
            fontSize: 15, color: Color(0xFF1A237E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              color: Color(0xFFB0BEC5)),
          prefixIcon: Icon(icon,
              color: const Color(0xFF7986CB), size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}