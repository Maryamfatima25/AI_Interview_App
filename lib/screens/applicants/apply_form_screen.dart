import 'package:flutter/material.dart';
import '../../models/applicant_model.dart';
import 'ai_interview_screen.dart';

class ApplyFormScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  const ApplyFormScreen({super.key, required this.job});

  @override
  State<ApplyFormScreen> createState() => _ApplyFormScreenState();
}

class _ApplyFormScreenState extends State<ApplyFormScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _skillsController = TextEditingController();
  String _experience = '0-1 years';
  bool _loading = false;

  final List<String> _experienceOptions = [
    '0-1 years', '1-2 years', '2-3 years', '3-5 years', '5+ years'
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill with session data
    _nameController.text = currentApplicant.name;
    _emailController.text = currentApplicant.email;
  }

  double _calculateMatchScore(List<String> enteredSkills) {
    final required = (widget.job['skills'] as List).cast<String>();
    if (required.isEmpty) return 0;
    final matched = enteredSkills
        .where((s) => required.map((r) => r.toLowerCase()).contains(s.toLowerCase()))
        .length;
    return (matched / required.length) * 100;
  }

  void _submit() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      _showSnack('Please fill in all required fields', isError: true);
      return;
    }
    if (!_emailController.text.contains('@')) {
      _showSnack('Enter a valid email address', isError: true);
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _loading = false);

    // Parse skills
    final skills = _skillsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // Calculate match score
    final score = _calculateMatchScore(skills);

    // Save to session
    currentApplicant.name = _nameController.text.trim();
    currentApplicant.email = _emailController.text.trim();
    currentApplicant.skills = skills;
    currentApplicant.experience = _experience;
    currentApplicant.appliedJobTitle = widget.job['title'] as String;
    currentApplicant.resumeMatchScore = score;

    if (mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => AiInterviewScreen(job: widget.job)));
    }
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
    final requiredSkills = (widget.job['skills'] as List).cast<String>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Apply for job',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF3949AB)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job title banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3949AB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.work_outline, color: Colors.white70, size: 20),
                  const SizedBox(width: 10),
                  Text(widget.job['title'] as String,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Personal Information'),
            const SizedBox(height: 14),

            _label('Full name *'),
            const SizedBox(height: 8),
            _field(_nameController, 'Your full name', Icons.person_outline),
            const SizedBox(height: 16),

            _label('Email address *'),
            const SizedBox(height: 8),
            _field(_emailController, 'your@email.com', Icons.email_outlined,
                keyboard: TextInputType.emailAddress),
            const SizedBox(height: 24),

            _sectionTitle('Skills & Experience'),
            const SizedBox(height: 14),

            // Hint for required skills
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EAF6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Required skills for this role:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                          color: Color(0xFF3949AB))),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: requiredSkills.map((s) => Chip(
                      label: Text(s, style: const TextStyle(fontSize: 11)),
                      backgroundColor: const Color(0xFF3949AB).withOpacity(0.12),
                      side: const BorderSide(color: Color(0xFF3949AB), width: 0.5),
                      padding: EdgeInsets.zero,
                    )).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _label('Your skills (comma-separated)'),
            const SizedBox(height: 8),
            _field(_skillsController, 'e.g. React, JavaScript, CSS',
                Icons.psychology_outlined),
            const SizedBox(height: 16),

            _label('Experience level'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _experience,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF7986CB)),
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1A237E)),
                  items: _experienceOptions.map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  )).toList(),
                  onChanged: (v) => setState(() => _experience = v!),
                ),
              ),
            ),
            const SizedBox(height: 36),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3949AB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(width: 22, height: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Submit & Start AI Interview',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)));

  Widget _label(String t) => Text(t,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF546E7A)));

  Widget _field(TextEditingController c, String hint, IconData icon,
      {TextInputType keyboard = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A237E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 13),
          prefixIcon: Icon(icon, color: const Color(0xFF7986CB), size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}