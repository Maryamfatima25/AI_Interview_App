import 'package:flutter/material.dart';
import '../../../../data/dummy_jobs.dart';
import 'job_detail_screen.dart';

class JobListingsScreen extends StatefulWidget {
  const JobListingsScreen({super.key});

  @override
  State<JobListingsScreen> createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends State<JobListingsScreen> {
  String _search = '';

  final List<Color> _cardColors = [
    const Color(0xFF3949AB),
    const Color(0xFF00897B),
    const Color(0xFF7E57C2),
    const Color(0xFFEF6C00),
  ];

  @override
  Widget build(BuildContext context) {
    final jobs = dummyJobs.where((j) {
      final title = (j['title'] as String).toLowerCase();
      return title.contains(_search.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Job Openings',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF3949AB)),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
              ),
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                style: const TextStyle(fontSize: 14, color: Color(0xFF1A237E)),
                decoration: const InputDecoration(
                  hintText: 'Search jobs...',
                  hintStyle: TextStyle(color: Color(0xFFB0BEC5)),
                  prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF7986CB), size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('${jobs.length} positions found',
                    style: const TextStyle(color: Color(0xFF7986CB), fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: jobs.isEmpty
                ? const Center(
                child: Text('No jobs found',
                    style: TextStyle(color: Color(0xFF9E9E9E))))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: jobs.length,
              itemBuilder: (ctx, i) {
                final job = jobs[i];
                final color = _cardColors[i % _cardColors.length];
                final skills = (job['skills'] as List).cast<String>();

                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => JobDetailScreen(job: job))),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                      ],
                    ),
                    child: Column(
                      children: [
                        // Color header
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
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
                                    Text(job['title'] as String,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text('${job['positions']} position(s) open',
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.white, size: 16),
                            ],
                          ),
                        ),
                        // Body
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.schedule_rounded,
                                      color: Color(0xFF7986CB), size: 16),
                                  const SizedBox(width: 6),
                                  Text(job['experience'] as String,
                                      style: const TextStyle(
                                          color: Color(0xFF7986CB), fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: skills.map((s) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: color.withOpacity(0.25)),
                                  ),
                                  child: Text(s,
                                      style: TextStyle(
                                          color: color,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                                )).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}