import 'package:flutter/material.dart';
import '../../data/dummy_jobs.dart';
import 'job_details_screen.dart';
import '../../data/job_store.dart';


class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  static const List<Color> _cardColors = [
    Color(0xFF3949AB),
    Color(0xFF00897B),
    Color(0xFF7E57C2),
    Color(0xFFEF6C00),
  ];

  @override
  Widget build(BuildContext context) {
    final jobs = postedJobs;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('All Jobs',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E))),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF3949AB)),
      ),
      body: jobsList.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF3949AB).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.work_off_outlined,
                  color: Color(0xFF7986CB), size: 40),
            ),
            const SizedBox(height: 16),
            const Text('No jobs available',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF37474F))),
            const SizedBox(height: 6),
            const Text('Create a job posting to get started',
                style: TextStyle(
                    fontSize: 13, color: Color(0xFF9E9E9E))),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: jobsList.length,
        itemBuilder: (context, index) {
          final job = jobsList[index];
          final color = _cardColors[index % _cardColors.length];
          final skills =
          (job['skills'] as List).cast<String>();

          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        JobDetailsScreen(job: job))),
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10)
                ],
              ),
              child: Column(
                children: [
                  // Colored header
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
                            color:
                            Colors.white.withOpacity(0.2),
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          child: const Icon(
                              Icons.work_outline,
                              color: Colors.white,
                              size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(job['title'] as String,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.bold)),
                              Text(
                                  '${job['positions']} position(s) open',
                                  style: TextStyle(
                                      color: Colors.white
                                          .withOpacity(0.8),
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 16),
                      ],
                    ),
                  ),

                  // Body
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                                Icons.schedule_rounded,
                                color: Color(0xFF7986CB),
                                size: 16),
                            const SizedBox(width: 6),
                            Text(job['experience'] as String,
                                style: const TextStyle(
                                    color: Color(0xFF7986CB),
                                    fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: skills
                              .map((s) => Container(
                            padding: const EdgeInsets
                                .symmetric(
                                horizontal: 10,
                                vertical: 4),
                            decoration: BoxDecoration(
                              color: color
                                  .withOpacity(0.08),
                              borderRadius:
                              BorderRadius.circular(
                                  20),
                              border: Border.all(
                                  color: color
                                      .withOpacity(
                                      0.25)),
                            ),
                            child: Text(s,
                                style: TextStyle(
                                    color: color,
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight
                                        .w500)),
                          ))
                              .toList(),
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
    );
  }
}