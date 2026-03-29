// lib/screens/applicant/applicant_dashboard_screen.dart

import 'package:flutter/material.dart';
import '../../data/dummy_jobs.dart';
import '../../models/applicant_model.dart';
import 'job_listings_screen.dart';
import 'applicant_login_screen.dart';

class ApplicantDashboardScreen extends StatefulWidget {
  const ApplicantDashboardScreen({super.key});

  @override
  State<ApplicantDashboardScreen> createState() => _ApplicantDashboardScreenState();
}

class _ApplicantDashboardScreenState extends State<ApplicantDashboardScreen> {

  // Called every time this screen comes back into focus
  // (e.g. returning from job listings, returning from interview)
  // This is what makes the journey steps and stats update live
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {}); // triggers rebuild with latest currentApplicant data
  }

  // Reads live from dummyJobs — no hardcoding
  int get _totalJobs => dummyJobs.length;

  // Reads live from session object
  bool get _hasApplied => currentApplicant.appliedJobTitle.isNotEmpty;
  bool get _hasInterviewed => currentApplicant.interviewScore > 0;
  bool get _hasResult => currentApplicant.aiVerdict.isNotEmpty;

  String get _displayName {
    if (currentApplicant.name.isNotEmpty) return currentApplicant.name;
    // Fallback: derive name from email
    if (currentApplicant.email.isNotEmpty) {
      return currentApplicant.email.split('@')[0];
    }
    return 'Applicant';
  }

  // void _logout() {
  //   // Reset the session so next login starts fresh
  //   currentApplicant = ApplicantModel();
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (_) => const ApplicantLoginScreen()),
  //         (route) => false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Top bar ──────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $_displayName 👋',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E)),
                      ),
                      const Text(
                        'Find your dream job today',
                        style: TextStyle(fontSize: 13, color: Color(0xFF7986CB)),
                      ),
                    ],
                  ),
                  GestureDetector(
                    // onTap: _logout,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8)
                        ],
                      ),
                      child: const Icon(Icons.logout_rounded,
                          color: Color(0xFF3949AB), size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Dynamic stats row ────────────────────────────
              Row(
                children: [
                  _statCard(
                    // reads live count from dummyJobs list
                    '$_totalJobs',
                    'Jobs available',
                    Icons.work_outline,
                    const Color(0xFF3949AB),
                  ),
                  const SizedBox(width: 14),
                  _statCard(
                    // 0 or 1 based on whether they applied
                    _hasApplied ? '1' : '0',
                    'Applied',
                    Icons.send_outlined,
                    const Color(0xFF00897B),
                  ),
                  const SizedBox(width: 14),
                  _statCard(
                    // shows score if interview done, else dash
                    _hasInterviewed
                        ? currentApplicant.interviewScore.toStringAsFixed(1)
                        : '-',
                    'AI Score',
                    Icons.stars_rounded,
                    const Color(0xFF7E57C2),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Applied job chip (only shows after applying) ─
              if (_hasApplied) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF43A047).withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: Color(0xFF43A047), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Applied for: ${currentApplicant.appliedJobTitle}',
                          style: const TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Main action card ─────────────────────────────
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const JobListingsScreen()),
                  );
                  // Rebuild when returning from job listings
                  setState(() {});
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3949AB),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF3949AB).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8))
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Browse Job Openings',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              // dynamic count from dummyJobs
                              '$_totalJobs positions available',
                              style: const TextStyle(
                                  fontSize: 13, color: Color(0xFFB3BCF5)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 24),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Journey tracker (fully dynamic) ─────────────
              const Text(
                'Your journey',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E)),
              ),
              const SizedBox(height: 16),

              _journeyStep(
                icon: Icons.search_rounded,
                title: 'Browse jobs',
                subtitle: '$_totalJobs positions available',
                color: const Color(0xFF5C6BC0),
                done: true, // always true once logged in
              ),
              _journeyStep(
                icon: Icons.description_outlined,
                title: 'Submit application',
                // shows which job they applied to, dynamically
                subtitle: _hasApplied
                    ? 'Applied for ${currentApplicant.appliedJobTitle}'
                    : 'Fill your profile and apply',
                color: const Color(0xFF26A69A),
                done: _hasApplied,
              ),
              _journeyStep(
                icon: Icons.smart_toy_outlined,
                title: 'AI interview',
                // shows score if done
                subtitle: _hasInterviewed
                    ? 'Scored ${currentApplicant.interviewScore.toStringAsFixed(1)}/10'
                    : 'Answer 5 AI-generated questions',
                color: const Color(0xFF7E57C2),
                done: _hasInterviewed,
              ),
              _journeyStep(
                icon: Icons.emoji_events_outlined,
                title: 'Get your result',
                // shows verdict snippet if done
                subtitle: _hasResult
                    ? currentApplicant.aiVerdict.length > 40
                    ? '${currentApplicant.aiVerdict.substring(0, 40)}...'
                    : currentApplicant.aiVerdict
                    : 'See your AI evaluation score',
                color: const Color(0xFFEF6C00),
                done: _hasResult,
                isLast: true,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── Widgets ────────────────────────────────────────────────

  Widget _statCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: Color(0xFF9E9E9E))),
          ],
        ),
      ),
    );
  }

  Widget _journeyStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool done,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: done ? color : color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                done ? Icons.check_rounded : icon,
                color: done ? Colors.white : color,
                size: 20,
              ),
            ),
            if (!isLast)
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 2,
                height: 40,
                color: done
                    ? color.withOpacity(0.4)
                    : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: done ? color : const Color(0xFF37474F)),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF9E9E9E)),
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ),
      ],
    );
  }
}