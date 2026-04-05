import 'package:flutter/material.dart';
import 'create_job_screen.dart';
import 'result_screen.dart';
import 'applicants_screen.dart';
import 'interview_screen.dart';
import 'result_screen_with_scores.dart';
import 'jobs_screen.dart';
import 'shortlist_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? createdJob;

  final List<_DashCard> _cards = const [
    _DashCard(
      title: 'Create Job',
      subtitle: 'Post a new opening',
      icon: Icons.add_box_rounded,
      color: Color(0xFF3949AB),
    ),
    _DashCard(
      title: 'Applicants',
      subtitle: 'Review submissions',
      icon: Icons.people_alt_rounded,
      color: Color(0xFF00897B),
    ),
    _DashCard(
      title: 'Shortlisted',
      subtitle: 'Top candidates',
      icon: Icons.verified_rounded,
      color: Color(0xFF7E57C2),
    ),
    _DashCard(
      title: 'Interview',
      subtitle: 'Conduct sessions',
      icon: Icons.video_camera_front_rounded,
      color: Color(0xFFEF6C00),
    ),
    _DashCard(
      title: 'Results',
      subtitle: 'View AI scores',
      icon: Icons.bar_chart_rounded,
      color: Color(0xFFE53935),
    ),
    _DashCard(
      title: 'View Jobs',
      subtitle: 'Manage listings',
      icon: Icons.work_rounded,
      color: Color(0xFF00838F),
    ),
  ];

  void _onCardTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CreateJobScreen()))
            .then((jobData) {
          if (jobData != null) setState(() => createdJob = jobData);
        });
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ApplicantsScreen()))
            .then((shortlisted) {
          if (shortlisted != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => InterviewScreen(
                        shortlistedCandidates: shortlisted)))
                .then((scores) {
              if (scores != null && createdJob != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ResultScreenWithScores(
                            job: createdJob!, interviewScores: scores)));
              }
            });
          }
        });
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ShortlistScreen()));
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InterviewScreen(shortlistedCandidates: []),
          ),
        );
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ResultScreen()));
        break;
      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const JobsScreen()));
        break;
    }
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Recruiter Dashboard',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E))),
                      Text('Manage your hiring pipeline',
                          style: TextStyle(
                              fontSize: 13, color: Color(0xFF7986CB))),
                    ],
                  ),
                  Container(
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
                    child: const Icon(Icons.notifications_none_rounded,
                        color: Color(0xFF3949AB), size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Active job banner
              if (createdJob != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3949AB),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color:
                          const Color(0xFF3949AB).withOpacity(0.28),
                          blurRadius: 16,
                          offset: const Offset(0, 6))
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.work_outline,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Active Job',
                                style: TextStyle(
                                    color: Color(0xFFB3BCF5),
                                    fontSize: 12)),
                            Text(createdJob!['title'] ?? '',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Live',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Section label
              const Text('Quick Actions',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E))),
              const SizedBox(height: 16),

              // Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _cards.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (ctx, i) {
                  final card = _cards[i];
                  return GestureDetector(
                    onTap: () => _onCardTap(i),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10)
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: card.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(card.icon,
                                color: card.color, size: 26),
                          ),
                          const SizedBox(height: 12),
                          Text(card.title,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: card.color)),
                          const SizedBox(height: 3),
                          Text(card.subtitle,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF9E9E9E))),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Pipeline steps
              const Text('Hiring Pipeline',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E))),
              const SizedBox(height: 14),

              _pipelineStep(
                icon: Icons.add_box_rounded,
                title: 'Post a job',
                subtitle: 'Define role and requirements',
                color: const Color(0xFF3949AB),
                done: createdJob != null,
              ),
              _pipelineStep(
                icon: Icons.people_alt_rounded,
                title: 'Review applicants',
                subtitle: 'Browse and evaluate candidates',
                color: const Color(0xFF00897B),
                done: false,
              ),
              _pipelineStep(
                icon: Icons.verified_rounded,
                title: 'Shortlist & interview',
                subtitle: 'Select top candidates',
                color: const Color(0xFF7E57C2),
                done: false,
              ),
              _pipelineStep(
                icon: Icons.emoji_events_outlined,
                title: 'Final results',
                subtitle: 'AI scores and recruiter decision',
                color: const Color(0xFFEF6C00),
                done: false,
                isLast: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pipelineStep({
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
            Container(
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
              Container(
                width: 2,
                height: 36,
                color: done
                    ? color.withOpacity(0.4)
                    : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: done ? color : const Color(0xFF37474F))),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF9E9E9E))),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashCard {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _DashCard(
      {required this.title,
        required this.subtitle,
        required this.icon,
        required this.color});
}