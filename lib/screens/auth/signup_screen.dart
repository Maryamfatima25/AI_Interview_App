import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  void _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showSnack('All fields are required', isError: true);
      return;
    }
    if (!email.contains('@')) {
      _showSnack('Enter a valid email', isError: true);
      return;
    }
    if (password.length < 6) {
      _showSnack('Password must be at least 6 characters', isError: true);
      return;
    }
    if (password != confirm) {
      _showSnack('Passwords do not match', isError: true);
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _loading = false);

    await AuthService.registerApplicant(email, password);
    _showSnack('Account created successfully!');
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) Navigator.pop(context);
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? const Color(0xFFE53935) : const Color(0xFF43A047),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3949AB)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _label('Email address'),
              const SizedBox(height: 8),
              _field(_emailController, 'you@example.com', Icons.email_outlined,
                  keyboard: TextInputType.emailAddress),
              const SizedBox(height: 20),
              _label('Password'),
              const SizedBox(height: 8),
              _field(_passwordController, 'Min 6 characters', Icons.lock_outline,
                  obscure: _obscure,
                  suffix: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                          size: 20),
                      onPressed: () => setState(() => _obscure = !_obscure))),
              const SizedBox(height: 20),
              _label('Confirm password'),
              const SizedBox(height: 8),
              _field(_confirmController, 'Repeat your password', Icons.lock_outline,
                  obscure: true),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3949AB),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _loading ? null : _signUp,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Create Account',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) =>
      Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13));

  Widget _field(TextEditingController c, String hint, IconData icon,
      {bool obscure = false, Widget? suffix, TextInputType keyboard = TextInputType.text}) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: c,
          obscureText: obscure,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            suffixIcon: suffix,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      );
}