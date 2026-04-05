import 'package:flutter/material.dart';
import 'applicants_screen.dart';

class JobDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> job;
  const JobDetailsScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final skills = (job['skills'] as List).cast<String>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: CustomScrollView(
        slivers: [
          // Colored SliverAppBar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF3949AB),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF3949AB),
                padding: const EdgeInsets.only(
                    left: 24, bottom: 24, right: 24, top: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.work_outline,
                        color: Colors.white70, size: 28),
                    const SizedBox(height: 8),
                    Text(job['title'] as String,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${job['positions']} open position(s)',
                        style: const TextStyle(
                            color: Color(0xFFB3BCF5), fontSize: 13)),
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
                  // Quick info chips
                  Row(
                    children: [
                      _infoChip(Icons.schedule_rounded,
                          job['experience'] as String),
                      const SizedBox(width: 10),
                      _infoChip(Icons.people_outline,
                          '${job['positions']} positions'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  if (job['description'] != null &&
                      job['description'].toString().isNotEmpty) ...[
                    _sectionTitle('Job Description'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8)
                        ],
                      ),
                      child: Text(job['description'] as String,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF37474F),
                              height: 1.6)),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Skills
                  _sectionTitle('Required Skills'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: skills
                        .map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3949AB)
                            .withOpacity(0.08),
                        borderRadius:
                        BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF3949AB)
                                .withOpacity(0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFF3949AB),
                              size: 14),
                          const SizedBox(width: 6),
                          Text(s,
                              style: const TextStyle(
                                  color: Color(0xFF3949AB),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13)),
                        ],
                      ),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 32),

                  // View Applicants button
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
                              builder: (_) => ApplicantsScreen(
                                  selectedJobTitle:
                                  job['title'] as String))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline,
                              color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('View Applicants',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
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
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A237E)));

  Widget _infoChip(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(
        horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6)
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF7986CB), size: 16),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: Color(0xFF37474F))),
      ],
    ),
  );
}