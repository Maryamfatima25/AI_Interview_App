import 'package:flutter/material.dart';
import '../../models/applicant_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _skillsController = TextEditingController();
  final _experienceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = currentApplicant.name;
    _emailController.text = currentApplicant.email;
    _skillsController.text = currentApplicant.skills.join(', ');
    _experienceController.text = currentApplicant.experience;
  }

  void _saveProfile() {
    setState(() {
      currentApplicant.name = _nameController.text.trim();
      currentApplicant.email = _emailController.text.trim();
      currentApplicant.skills = _skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      currentApplicant.experience = _experienceController.text.trim();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF3949AB)),
            onPressed: _saveProfile,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.account_circle, size: 100, color: Color(0xFF3949AB)),
            ),
            const SizedBox(height: 32),
            
            _label('Full Name'),
            const SizedBox(height: 8),
            _field(_nameController, 'Enter your name', Icons.person_outline),
            
            const SizedBox(height: 20),
            _label('Email'),
            const SizedBox(height: 8),
            _field(_emailController, 'Enter your email', Icons.email_outlined, keyboard: TextInputType.emailAddress),
            
            const SizedBox(height: 20),
            _label('Skills (comma separated)'),
            const SizedBox(height: 8),
            _field(_skillsController, 'e.g. Flutter, Dart, React', Icons.psychology_outlined),
            
            const SizedBox(height: 20),
            _label('Experience Level'),
            const SizedBox(height: 8),
            _field(_experienceController, 'e.g. 3 years', Icons.history_rounded),
            
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF3949AB)));

  Widget _field(TextEditingController controller, String hint, IconData icon, {TextInputType keyboard = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF7986CB), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}
