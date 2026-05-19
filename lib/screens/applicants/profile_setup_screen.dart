import 'package:flutter/material.dart';
import '../../services/cv_parser_service.dart';
import '../../models/applicant_model.dart';
import '../../models/generated_profile.dart';
import 'profile_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  bool _parsing = false;
  GeneratedProfile? _profile;

  void _pickCV() async {
    setState(() => _parsing = true);
    final profile = await CVParserService.pickAndParse();
    setState(() {
      _parsing = false;
      _profile = profile;
    });

    if (profile != null) {
      // Update the session applicant
      currentApplicant.name = profile.fullName;
      if (profile.email.isNotEmpty) currentApplicant.email = profile.email;
      currentApplicant.skills = profile.skills;
      
      _showSnack('CV Parsed Successfully!', isError: false);
    } else {
      _showSnack('Failed to parse CV or cancelled.', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red : Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('My Profile Setup'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.account_circle_outlined, size: 80, color: Color(0xFF3949AB)),
            const SizedBox(height: 16),
            const Text(
              'Upload your CV to auto-fill your profile',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF1A237E), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We will extract your skills and experience to match you with the best jobs.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _parsing ? null : _pickCV,
                icon: _parsing 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.upload_file),
                label: Text(_parsing ? 'Parsing CV...' : 'Upload CV (PDF)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3949AB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            
            if (_profile != null) ...[
              const SizedBox(height: 40),
              _buildExtractedInfo(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExtractedInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Extracted Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1A237E))),
          const Divider(height: 32),
          _infoRow(Icons.person, 'Name', _profile!.fullName),
          _infoRow(Icons.email, 'Email', _profile!.email),
          const SizedBox(height: 16),
          const Text('Detected Skills:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _profile!.skills.map((s) => Chip(
              label: Text(s, style: const TextStyle(fontSize: 12)),
              backgroundColor: const Color(0xFFE8EAF6),
            )).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              },
              child: const Text('Confirm and View Profile'),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF7986CB)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(value.isEmpty ? 'Not found' : value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
