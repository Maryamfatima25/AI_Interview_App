import 'package:flutter/material.dart';
import '../../models/applicant_model.dart';
import '../../data/applicant_store.dart';
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
  final List<String> _selectedSkills = [];
  String _experience = '0-1 years';
  bool _loading = false;

  final List<String> _experienceOptions = const [
    '0-1 years',
    '1-2 years',
    '2-3 years',
    '3-5 years',
    '5+ years',
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = currentApplicant.name;
    _emailController.text = currentApplicant.email;
    if (currentApplicant.experience.isNotEmpty) {
      _experience = currentApplicant.experience;
    }
  }

  double _calculateMatchScore() {
    final required = (widget.job['skills'] as List).cast<String>();
    if (required.isEmpty) return 100.0;
    
    int matched = 0;
    for (var s in _selectedSkills) {
      if (required.any((r) => r.toLowerCase().trim() == s.toLowerCase().trim())) {
        matched++;
      }
    }
    return (matched / required.length) * 100;
  }

  void _submit() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      _showSnack('Please fill in all required fields', isError: true);
      return;
    }

    if (_selectedSkills.isEmpty) {
      _showSnack('Please select at least one skill from your CV', isError: true);
      return;
    }

    final matchScore = _calculateMatchScore();
    currentApplicant.resumeMatchScore = matchScore;

    if (matchScore <= 75) {
      _showLowScoreDialog(matchScore);
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _loading = false);

    // Save to session
    currentApplicant.name = _nameController.text.trim();
    currentApplicant.email = _emailController.text.trim();
    currentApplicant.experience = _experience;
    currentApplicant.appliedJobTitle = widget.job['title'] as String;

    // Add to submitted list
    submittedApplicants.add(ApplicantModel(
      name: currentApplicant.name,
      email: currentApplicant.email,
      skills: List<String>.from(_selectedSkills),
      experience: currentApplicant.experience,
      appliedJobTitle: currentApplicant.appliedJobTitle,
      resumeMatchScore: matchScore,
      interviewScore: 0.0,
      aiVerdict: '',
    ));
    
    await saveApplicantsToFile();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AiInterviewScreen(job: widget.job),
        ),
      );
    }
  }

  void _showLowScoreDialog(double score) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Match Score Too Low'),
        content: Text('Your skill match score is ${score.toStringAsFixed(0)}%. You need at least 75% to proceed to the interview.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red : Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final requiredSkills = (widget.job['skills'] as List).cast<String>();
    final cvSkills = currentApplicant.skills.isEmpty 
        ? ['No skills found in CV'] 
        : currentApplicant.skills;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(title: const Text('Apply for Job')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3949AB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(widget.job['title'], 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Personal Info'),
            const SizedBox(height: 12),
            _field(_nameController, 'Full Name', Icons.person),
            const SizedBox(height: 12),
            _field(_emailController, 'Email', Icons.email),
            
            const SizedBox(height: 24),
            _sectionTitle('Experience'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _experience,
                  items: _experienceOptions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => _experience = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitle('CV Skill Selection'),
            const Text('Select skills from your CV that match the job requirements:', 
              style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            
            // Required skills reminder
            Wrap(
              spacing: 8,
              children: requiredSkills.map((s) => Chip(
                label: Text(s, style: const TextStyle(fontSize: 10)),
                backgroundColor: Colors.blue.shade50,
              )).toList(),
            ),
            const SizedBox(height: 12),

            // Dropdown to select skills from CV
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Select skills from your CV'),
                  items: cvSkills.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (val) {
                    if (val != null && val != 'No skills found in CV' && !_selectedSkills.contains(val)) {
                      setState(() => _selectedSkills.add(val));
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Selected skills chips
            Wrap(
              spacing: 8,
              children: _selectedSkills.map((s) => Chip(
                label: Text(s),
                onDeleted: () => setState(() => _selectedSkills.remove(s)),
                backgroundColor: const Color(0xFFE8EAF6),
              )).toList(),
            ),

            const SizedBox(height: 24),
            _sectionTitle('Match Assessment'),
            const SizedBox(height: 8),
            Text('Current Match Score: ${_calculateMatchScore().toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold, 
                color: _calculateMatchScore() > 75 ? Colors.green : Colors.orange
              )),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('Proceed to AI Interview'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));

  Widget _field(TextEditingController c, String hint, IconData icon) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}
