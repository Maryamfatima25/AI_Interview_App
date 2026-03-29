// import 'package:flutter/material.dart';
// import 'applicant_dashboard_screen.dart';
// import 'applicant_register_screen.dart';
// import 'models/applicant_model.dart';
//
// class ApplicantLoginScreen extends StatefulWidget {
//   const ApplicantLoginScreen({super.key});
//
//   @override
//   State<ApplicantLoginScreen> createState() => _ApplicantLoginScreenState();
// }
//
// class _ApplicantLoginScreenState extends State<ApplicantLoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscure = true;
//   bool _loading = false;
//
//   void _login() async {
//     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
//       _showSnack('Please fill in all fields', isError: true);
//       return;
//     }
//     if (!_emailController.text.contains('@')) {
//       _showSnack('Enter a valid email', isError: true);
//       return;
//     }
//
//     setState(() => _loading = true);
//     await Future.delayed(const Duration(milliseconds: 800));
//     setState(() => _loading = false);
//
//     // Store in session
//     currentApplicant.email = _emailController.text.trim();
//     currentApplicant.name = _emailController.text.split('@')[0];
//
//     _showSnack('Welcome back!');
//     await Future.delayed(const Duration(milliseconds: 600));
//     if (mounted) {
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (_) => const ApplicantDashboardScreen()));
//     }
//   }
//
//   void _showSnack(String msg, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg),
//       backgroundColor: isError ? const Color(0xFFE53935) : const Color(0xFF43A047),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F4FF),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 40),
//               // Header
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF3949AB),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: const Icon(Icons.person_search_rounded, color: Colors.white, size: 32),
//               ),
//               const SizedBox(height: 24),
//               const Text('Welcome back',
//                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
//               const SizedBox(height: 6),
//               const Text('Sign in to your applicant account',
//                   style: TextStyle(fontSize: 14, color: Color(0xFF7986CB))),
//               const SizedBox(height: 40),
//
//               // Email field
//               _label('Email address'),
//               const SizedBox(height: 8),
//               _textField(
//                 controller: _emailController,
//                 hint: 'you@example.com',
//                 icon: Icons.email_outlined,
//                 keyboard: TextInputType.emailAddress,
//               ),
//               const SizedBox(height: 20),
//
//               // Password field
//               _label('Password'),
//               const SizedBox(height: 8),
//               _textField(
//                 controller: _passwordController,
//                 hint: 'Enter your password',
//                 icon: Icons.lock_outline,
//                 obscure: _obscure,
//                 suffix: IconButton(
//                   icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
//                       color: const Color(0xFF7986CB), size: 20),
//                   onPressed: () => setState(() => _obscure = !_obscure),
//                 ),
//               ),
//               const SizedBox(height: 36),
//
//               // Login button
//               SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF3949AB),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//                     elevation: 0,
//                   ),
//                   onPressed: _loading ? null : _login,
//                   child: _loading
//                       ? const SizedBox(
//                       width: 22, height: 22,
//                       child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                       : const Text('Sign In',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
//                 ),
//               ),
//               const SizedBox(height: 24),
//
//               // Register link
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Don't have an account? ",
//                       style: TextStyle(color: Color(0xFF7986CB))),
//                   GestureDetector(
//                     onTap: () => Navigator.push(context,
//                         MaterialPageRoute(builder: (_) => const ApplicantRegisterScreen())),
//                     child: const Text('Register',
//                         style: TextStyle(
//                             color: Color(0xFF3949AB), fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _label(String text) => Text(text,
//       style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF3949AB)));
//
//   Widget _textField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     bool obscure = false,
//     Widget? suffix,
//     TextInputType keyboard = TextInputType.text,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: const Color(0xFF3949AB).withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: obscure,
//         keyboardType: keyboard,
//         style: const TextStyle(fontSize: 15, color: Color(0xFF1A237E)),
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: const TextStyle(color: Color(0xFFB0BEC5)),
//           prefixIcon: Icon(icon, color: const Color(0xFF7986CB), size: 20),
//           suffixIcon: suffix,
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//         ),
//       ),
//     );
//   }
// }