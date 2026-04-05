import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  void _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passwordController.text;
    final confirm = _confirmController.text;

    if (name.isEmpty || email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      _showSnack('All fields are required', isError: true);
      return;
    }
    if (!email.contains('@')) {
      _showSnack('Enter a valid email', isError: true);
      return;
    }
    if (pass.length < 6) {
      _showSnack('Password must be at least 6 characters', isError: true);
      return;
    }
    if (pass != confirm) {
      _showSnack('Passwords do not match', isError: true);
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() => _loading = false);

    _showSnack('Account created successfully!');
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) Navigator.pop(context);
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3949AB)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3949AB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person_add_rounded,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(height: 24),

              const Text('Create account',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E))),
              const SizedBox(height: 6),
              const Text('Join the platform today',
                  style:
                  TextStyle(fontSize: 14, color: Color(0xFF7986CB))),
              const SizedBox(height: 36),

              _label('Full name'),
              const SizedBox(height: 8),
              _field(_nameController, 'Your full name',
                  Icons.person_outline),
              const SizedBox(height: 20),

              _label('Email address'),
              const SizedBox(height: 8),
              _field(_emailController, 'you@example.com',
                  Icons.email_outlined,
                  keyboard: TextInputType.emailAddress),
              const SizedBox(height: 20),

              _label('Password'),
              const SizedBox(height: 8),
              _field(
                _passwordController,
                'Min 6 characters',
                Icons.lock_outline,
                obscure: _obscure,
                suffix: IconButton(
                  icon: Icon(
                      _obscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF7986CB),
                      size: 20),
                  onPressed: () =>
                      setState(() => _obscure = !_obscure),
                ),
              ),
              const SizedBox(height: 20),

              _label('Confirm password'),
              const SizedBox(height: 8),
              _field(_confirmController, 'Repeat your password',
                  Icons.lock_outline,
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
                    elevation: 0,
                  ),
                  onPressed: _loading ? null : _signUp,
                  child: _loading
                      ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                      : const Text('Create Account',
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
                  const Text('Already have an account? ',
                      style: TextStyle(color: Color(0xFF7986CB))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Sign In',
                        style: TextStyle(
                            color: Color(0xFF3949AB),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
        style:
        const TextStyle(fontSize: 15, color: Color(0xFF1A237E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFB0BEC5)),
          prefixIcon:
          Icon(icon, color: const Color(0xFF7986CB), size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}