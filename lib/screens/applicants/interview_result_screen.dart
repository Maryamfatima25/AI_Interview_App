import 'package:flutter/material.dart';
import '../../models/applicant_model.dart';
import 'applicant_dashboard_screen.dart';
// ADD this line alongside existing imports
import '../../data/applicant_store.dart';
import '../../services/applicant_profile_cache.dart';
import '../../services/auth_service.dart';

class InterviewResultScreen extends StatefulWidget {
  const InterviewResultScreen({super.key});

  @override
  State<InterviewResultScreen> createState() => _InterviewResultScreenState();
}

class _InterviewResultScreenState extends State<InterviewResultScreen> {
  @override
  void initState() {
    super.initState();
    _persistResults();
  }

  Future<void> _persistResults() async {
    final score = currentApplicant.interviewScore;

    // Update the last submitted applicant's score so recruiter sees it
    if (submittedApplicants.isNotEmpty) {
      submittedApplicants.last.interviewScore = score;
      submittedApplicants.last.aiVerdict = currentApplicant.aiVerdict;
      await saveApplicantsToFile();
    }
    final uid = AuthService.currentUid;
    if (uid != null) {
      await ApplicantProfileCache.save(uid, currentApplicant);
    }
  }

  Color _scoreColor(double score) {
    if (score >= 8) return const Color(0xFF2E7D32);
    if (score >= 6) return const Color(0xFF1565C0);
    if (score >= 4) return const Color(0xFFE65100);
    return const Color(0xFFC62828);
  }

  String _scoreLabel(double score) {
    if (score >= 8) return 'Excellent';
    if (score >= 6) return 'Good';
    if (score >= 4) return 'Average';
    return 'Below Average';
  }

  IconData _scoreIcon(double score) {
    if (score >= 8) return Icons.emoji_events_rounded;
    if (score >= 6) return Icons.thumb_up_rounded;
    if (score >= 4) return Icons.trending_up_rounded;
    return Icons.school_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final score = currentApplicant.interviewScore;
    final color = _scoreColor(score);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Big score circle
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.1),
                  border: Border.all(color: color, width: 4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_scoreIcon(score), color: color, size: 28),
                    const SizedBox(height: 6),
                    Text(
                      score.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      'out of 10',
                      style: TextStyle(
                        fontSize: 12,
                        color: color.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                _scoreLabel(score),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currentApplicant.aiVerdict,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF546E7A),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Score card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Interview Score',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _scoreRow(
                      'Interview score',
                      score,
                      10,
                      const Color(0xFF3949AB),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Applicant info card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _infoRow(
                      Icons.person_outline,
                      'Name',
                      currentApplicant.name,
                    ),
                    const Divider(height: 20),
                    _infoRow(
                      Icons.work_outline,
                      'Applied for',
                      currentApplicant.appliedJobTitle,
                    ),
                    const Divider(height: 20),
                    _infoRow(
                      Icons.schedule_rounded,
                      'Experience',
                      currentApplicant.experience.isEmpty
                          ? 'Not specified'
                          : currentApplicant.experience,
                    ),
                    if (currentApplicant.skills.isNotEmpty) ...[
                      const Divider(height: 20),
                      _infoRow(
                        Icons.psychology_outlined,
                        'Skills',
                        currentApplicant.skills.join(', '),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // What's next
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF3949AB).withOpacity(0.2),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF3949AB),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your results have been submitted. The recruiter will review top candidates and contact you.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF3949AB),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Back to dashboard
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3949AB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ApplicantDashboardScreen(),
                    ),
                    (route) => false,
                  ),
                  child: const Text(
                    'Back to Dashboard',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreRow(String label, double value, double max, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF546E7A)),
            ),
            Text(
              '${value.toStringAsFixed(1)} / ${max.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value / max,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF7986CB), size: 18),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF37474F),
            ),
          ),
        ),
      ],
    );
  }
}
