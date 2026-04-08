import 'package:flutter/material.dart';
import '../recruiter/dashboard_screen.dart';
import '../applicants/applicant_dashboard_screen.dart';
import 'signup_screen.dart';
import '../../services/auth_service.dart'; // UserRole is now defined here

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  void _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnack('Please fill in all fields', isError: true);
      return;
    }
    if (!emailController.text.contains('@')) {
      _showSnack('Enter a valid email', isError: true);
      return;
    }

    setState(() => _loading = true);

    final role = await AuthService.login(
        emailController.text.trim(), passwordController.text.trim());

    setState(() => _loading = false);

    if (!mounted) return;

    if (role == UserRole.recruiter) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()));
    } else if (role == UserRole.applicant) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const ApplicantDashboardScreen()));
    } else {
      _showSnack('Invalid email or password', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor:
      isError ? const Color(0xFFE53935) : const Color(0xFF43A047),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3949AB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.lock_open_rounded,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(height: 24),
              const Text('Welcome back',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E))),
              const SizedBox(height: 6),
              const Text('Sign in to continue',
                  style:
                  TextStyle(fontSize: 14, color: Color(0xFF7986CB))),
              const SizedBox(height: 40),

              _label('Email address'),
              const SizedBox(height: 8),
              _textField(
                controller: emailController,
                hint: 'you@example.com',
                icon: Icons.email_outlined,
                keyboard: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              _label('Password'),
              const SizedBox(height: 8),
              _textField(
                controller: passwordController,
                hint: 'Enter your password',
                icon: Icons.lock_outline,
                obscure: _obscure,
                suffix: IconButton(
                  icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF7986CB),
                      size: 20),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3949AB),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                      : const Text('Sign In',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ",
                      style: TextStyle(color: Color(0xFF7986CB))),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SignUpScreen())),
                    child: const Text('Sign Up',
                        style: TextStyle(
                            color: Color(0xFF3949AB),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3949AB)));

  Widget _textField({
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
        style: const TextStyle(fontSize: 15, color: Color(0xFF1A237E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFB0BEC5)),
          prefixIcon:
          Icon(icon, color: const Color(0xFF7986CB), size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}