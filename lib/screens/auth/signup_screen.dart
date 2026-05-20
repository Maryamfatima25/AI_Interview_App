import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();
  final _confirmCtrl  = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _register() async {
    final name    = _nameCtrl.text.trim();
    final email   = _emailCtrl.text.trim();
    final pass    = _passCtrl.text;
    final confirm = _confirmCtrl.text;

    // Validation
    if (name.isEmpty || email.isEmpty ||
        pass.isEmpty || confirm.isEmpty) {
      _snack('All fields are required', error: true);
      return;
    }
    if (!email.contains('@')) {
      _snack('Enter a valid email', error: true);
      return;
    }
    if (pass.length < 6) {
      _snack('Password must be at least 6 characters',
          error: true);
      return;
    }
    if (pass != confirm) {
      _snack('Passwords do not match', error: true);
      return;
    }

    setState(() => _loading = true);

    // Always signs up as applicant
    final error = await AuthService.signUp(
      name:     name,
      email:    email,
      password: pass,
    );

    setState(() => _loading = false);

    if (error != null) {
      _snack(error, error: true);
      return;
    }

    _snack('Account created! Please sign in.');
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => const LoginScreen()),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme:
        const IconThemeData(color: Color(0xFF3949AB)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 28, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create account',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E))),
              const SizedBox(height: 6),
              const Text(
                'Join as a job applicant',
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7986CB)),
              ),
              const SizedBox(height: 8),

              // Info banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Color(0xFF3949AB), size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Recruiter accounts are managed by the organization.',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF3949AB)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              _label('Full name'),
              const SizedBox(height: 8),
              _field(_nameCtrl, 'Your full name',
                  Icons.person_outline),
              const SizedBox(height: 16),

              _label('Email address'),
              const SizedBox(height: 8),
              _field(_emailCtrl, 'you@example.com',
                  Icons.email_outlined,
                  keyboard: TextInputType.emailAddress),
              const SizedBox(height: 16),

              _label('Password'),
              const SizedBox(height: 8),
              _field(
                _passCtrl,
                'Min 6 characters',
                Icons.lock_outline,
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
              const SizedBox(height: 16),

              _label('Confirm password'),
              const SizedBox(height: 8),
              _field(_confirmCtrl, 'Repeat your password',
                  Icons.lock_outline, obscure: true),
              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _register,
                  child: _loading
                      ? const SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2))
                      : const Text('Create Account',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ',
                      style: TextStyle(
                          color: Color(0xFF7986CB))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Sign In',
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

  Widget _label(String t) => Text(t,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3949AB)));

  Widget _field(
      TextEditingController c,
      String hint,
      IconData icon, {
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
        controller: c,
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