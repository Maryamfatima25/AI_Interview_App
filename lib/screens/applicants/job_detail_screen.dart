import 'package:flutter/material.dart';
import 'apply_form_screen.dart';

class JobDetailScreen extends StatelessWidget {
  final Map<String, dynamic> job;
  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final skills = (job['skills'] as List).cast<String>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: CustomScrollView(
        slivers: [
          // Big colored app bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF3949AB),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF3949AB),
                padding: const EdgeInsets.only(left: 24, bottom: 24, right: 24, top: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.work_outline, color: Colors.white70, size: 28),
                    const SizedBox(height: 8),
                    Text(job['title'] as String,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${job['positions']} open position(s)',
                        style: const TextStyle(color: Color(0xFFB3BCF5), fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick info row
                  Row(
                    children: [
                      _infoChip(Icons.schedule_rounded, job['experience'] as String),
                      const SizedBox(width: 10),
                      _infoChip(Icons.people_outline, '${job['positions']} positions'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _sectionTitle('Job Description'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
                      ],
                    ),
                    child: Text(job['description'] as String,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF37474F), height: 1.6)),
                  ),
                  const SizedBox(height: 24),

                  _sectionTitle('Required Skills'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: skills.map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3949AB).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF3949AB).withOpacity(0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_outline,
                              color: Color(0xFF3949AB), size: 14),
                          const SizedBox(width: 6),
                          Text(s,
                              style: const TextStyle(
                                  color: Color(0xFF3949AB),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13)),
                        ],
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 32),

                  // What happens next
                  _sectionTitle('What happens after applying?'),
                  const SizedBox(height: 12),
                  _nextStep('01', 'Your skills are matched against requirements'),
                  _nextStep('02', 'You attend a 5-question AI interview'),
                  _nextStep('03', 'AI evaluates and gives you a score'),
                  _nextStep('04', 'Recruiter reviews top candidates'),
                  const SizedBox(height: 40),

                  // Apply button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3949AB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ApplyFormScreen(job: job))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Apply Now',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)));

  Widget _infoChip(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF7986CB), size: 16),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF37474F))),
      ],
    ),
  );

  Widget _nextStep(String num, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF3949AB).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(num,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3949AB))),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF546E7A))),
        ),
      ],
    ),
  );
}