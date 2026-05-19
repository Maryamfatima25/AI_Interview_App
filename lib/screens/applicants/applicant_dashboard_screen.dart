import 'package:ai_interview_app/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import '../../models/applicant_model.dart';
import '../../data/job_store.dart';
import '../../data/applicant_store.dart';
import 'job_listings_screen.dart';
import 'my_applicant_screen.dart';
import 'profile_setup_screen.dart';
import 'profile_screen.dart';

class ApplicantDashboardScreen extends StatefulWidget {
  const ApplicantDashboardScreen({super.key});

  @override
  State<ApplicantDashboardScreen> createState() =>
      _ApplicantDashboardScreenState();
}

class _ApplicantDashboardScreenState
    extends State<ApplicantDashboardScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  int get _totalJobs => allJobsForApplicant.length;

  // ── Count real submissions for THIS applicant ──────────────────────────
  int get _appliedCount => submittedApplicants
      .where((a) => a.email == currentApplicant.email)
      .length;

  bool get _hasApplied => currentApplicant.appliedJobTitle.isNotEmpty;
  bool get _hasInterviewed => currentApplicant.interviewScore > 0;
  bool get _hasResult => currentApplicant.aiVerdict.isNotEmpty;

  String get _displayName {
    if (currentApplicant.name.isNotEmpty) return currentApplicant.name;
    if (currentApplicant.email.isNotEmpty)
      return currentApplicant.email.split('@')[0];
    return 'Applicant';
  }

  void _logout() {
    currentApplicant = ApplicantModel();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  // ── Navigate helpers ───────────────────────────────────────────────────
  void _goToJobs() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (_) => const JobListingsScreen()));
    setState(() {});
  }

  void _goToApplications() {
    if (_appliedCount == 0) return; // nothing to show
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const MyApplicationsScreen()));
  }

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

              // ── Top bar ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (currentApplicant.skills.isEmpty) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileSetupScreen()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8)],
                      ),
                      child: const Icon(Icons.person_rounded,
                          color: Color(0xFF3949AB), size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Hello, $_displayName 👋',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A237E))),
                        const Text('Find your dream job today',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF7986CB))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _logout,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8)],
                      ),
                      child: const Icon(Icons.logout_rounded,
                          color: Color(0xFF3949AB), size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Stats row — all 3 are now tappable ───────────────────
              Row(
                children: [
                  // Jobs available → JobListingsScreen
                  _statCard(
                    value: '$_totalJobs',
                    label: 'Jobs available',
                    icon: Icons.work_outline,
                    color: const Color(0xFF3949AB),
                    onTap: _goToJobs,
                  ),
                  const SizedBox(width: 14),
                  // Applied → MyApplicationsScreen
                  _statCard(
                    value: '$_appliedCount',
                    label: 'Applied',
                    icon: Icons.send_outlined,
                    color: const Color(0xFF00897B),
                    onTap: _goToApplications,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Applied chip ──────────────────────────────────────────
              if (_hasApplied) ...[
                GestureDetector(
                  onTap: _goToApplications,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFF43A047).withOpacity(0.3)),
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
                        const Icon(Icons.arrow_forward_ios_rounded,
                            size: 12, color: Color(0xFF43A047)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Main browse card ──────────────────────────────────────
              GestureDetector(
                onTap: _goToJobs,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3949AB),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(
                        color: const Color(0xFF3949AB).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8))],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Browse Job Openings',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 6),
                            Text('$_totalJobs positions available',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFFB3BCF5))),
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

              // ── Journey tracker ───────────────────────────────────────
              const Text('Your journey',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E))),
              const SizedBox(height: 16),

              _journeyStep(
                icon: Icons.upload_file_rounded,
                title: 'Upload CV',
                subtitle: currentApplicant.skills.isNotEmpty 
                    ? 'CV parsed successfully' 
                    : 'Get matched better with a CV',
                color: const Color(0xFF3949AB),
                done: currentApplicant.skills.isNotEmpty,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileSetupScreen())),
              ),
              _journeyStep(
                icon: Icons.search_rounded,
                title: 'Browse jobs',
                subtitle: '$_totalJobs positions available',
                color: const Color(0xFF5C6BC0),
                done: true,
                onTap: _goToJobs,
              ),
              _journeyStep(
                icon: Icons.description_outlined,
                title: 'Submit application',
                subtitle: _hasApplied
                    ? 'Applied for ${currentApplicant.appliedJobTitle}'
                    : 'Fill your profile and apply',
                color: const Color(0xFF26A69A),
                done: _hasApplied,
                onTap: _hasApplied ? _goToApplications : _goToJobs,
              ),
              _journeyStep(
                icon: Icons.smart_toy_outlined,
                title: 'AI interview',
                subtitle: _hasInterviewed
                    ? 'Scored ${currentApplicant.interviewScore.toStringAsFixed(1)}/10'
                    : 'Answer 5 AI-generated questions',
                color: const Color(0xFF7E57C2),
                done: _hasInterviewed,
                onTap: null,
              ),
              _journeyStep(
                icon: Icons.emoji_events_outlined,
                title: 'Get your result',
                subtitle: _hasResult
                    ? currentApplicant.aiVerdict.length > 40
                    ? '${currentApplicant.aiVerdict.substring(0, 40)}...'
                    : currentApplicant.aiVerdict
                    : 'See your AI evaluation score',
                color: const Color(0xFFEF6C00),
                done: _hasResult,
                isLast: true,
                onTap: null,
              ),
              const SizedBox(height: 20),

              // ── My Applications preview ───────────────────────────────
              if (_appliedCount > 0) ...[
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Applications',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E))),
                    GestureDetector(
                      onTap: _goToApplications,
                      child: const Text('View all',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF3949AB),
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _goToApplications,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3949AB).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.description_outlined,
                              color: Color(0xFF3949AB), size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                submittedApplicants
                                    .lastWhere(
                                      (a) => a.email == currentApplicant.email,
                                  orElse: () => submittedApplicants.last,
                                )
                                    .appliedJobTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF1A237E)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$_appliedCount job(s) applied · Tap to view all',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: onTap != null
                ? Border.all(color: color.withOpacity(0.2))
                : null,
            boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.05), blurRadius: 10)],
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
              // Tap hint for tappable cards
              if (onTap != null) ...[
                const SizedBox(height: 4),
                Text('Tap to view',
                    style: TextStyle(
                        fontSize: 9,
                        color: color.withOpacity(0.6))),
              ],
            ],
          ),
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
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
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
                  Row(
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: done
                                  ? color
                                  : const Color(0xFF37474F))),
                      if (onTap != null && done) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 10, color: color),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF9E9E9E))),
                  const SizedBox(height: 22),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}