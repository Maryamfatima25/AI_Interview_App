import 'package:flutter/material.dart';
import '../../services/job_service.dart';
import '../../utils/data_helper.dart';
import 'job_detail_screen.dart';

class JobListingsScreen extends StatefulWidget {
  const JobListingsScreen({super.key});

  @override
  State<JobListingsScreen> createState() =>
      _JobListingsScreenState();
}

class _JobListingsScreenState
    extends State<JobListingsScreen> {
  String _search = '';

  final List<Color> _colors = [
    const Color(0xFF3949AB),
    const Color(0xFF00897B),
    const Color(0xFF7E57C2),
    const Color(0xFFEF6C00),
    const Color(0xFF1565C0),
    const Color(0xFF2E7D32),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Job Openings',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E))),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme:
        const IconThemeData(color: Color(0xFF3949AB)),
      ),
      body: Column(
        children: [

          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8)],
              ),
              child: TextField(
                onChanged: (v) =>
                    setState(() => _search = v),
                decoration: const InputDecoration(
                  hintText: 'Search jobs...',
                  hintStyle: TextStyle(
                      color: Color(0xFFB0BEC5)),
                  prefixIcon: Icon(Icons.search_rounded,
                      color: Color(0xFF7986CB), size: 20),
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: JobService.getJobsStream(),
              builder: (context, snapshot) {
                // ── Hybrid: merge Firebase + dummy ───────
                final firebaseJobs = snapshot.data ?? [];
                final allJobs = mergeJobs(firebaseJobs);

                // Apply search filter
                final jobs = allJobs.where((j) {
                  return (j['title'] as String)
                      .toLowerCase()
                      .contains(_search.toLowerCase());
                }).toList();

                final liveCount = firebaseJobs.length;
                final isLoading = snapshot.connectionState
                    == ConnectionState.waiting;

                return Column(
                  children: [
                    // Stats row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            '${jobs.length} positions found',
                            style: const TextStyle(
                                color: Color(0xFF7986CB),
                                fontSize: 13),
                          ),
                          const Spacer(),
                          // Live badge if Firebase has data
                          if (liveCount > 0)
                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF43A047)
                                    .withOpacity(0.1),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  const Icon(Icons.circle,
                                      color:
                                      Color(0xFF43A047),
                                      size: 7),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$liveCount live',
                                    style: const TextStyle(
                                        color: Color(
                                            0xFF43A047),
                                        fontSize: 11,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          if (isLoading)
                            const SizedBox(
                              width: 14, height: 14,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF3949AB)),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Job cards
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        itemCount: jobs.length,
                        itemBuilder: (ctx, i) {
                          final job = jobs[i];
                          final color =
                          _colors[i % _colors.length];
                          final skills =
                          (job['skills'] as List? ?? [])
                              .cast<String>();
                          final isDemo =
                              job['isDemo'] == true;

                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    JobDetailScreen(
                                        job: job),
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(
                                    16),
                                boxShadow: [BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.05),
                                    blurRadius: 10)],
                              ),
                              child: Column(
                                children: [
                                  // Header
                                  Container(
                                    padding:
                                    const EdgeInsets
                                        .all(18),
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius:
                                      const BorderRadius
                                          .only(
                                        topLeft:
                                        Radius.circular(
                                            16),
                                        topRight:
                                        Radius.circular(
                                            16),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding:
                                          const EdgeInsets
                                              .all(10),
                                          decoration:
                                          BoxDecoration(
                                            color: Colors
                                                .white
                                                .withOpacity(
                                                0.2),
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                10),
                                          ),
                                          child: const Icon(
                                              Icons
                                                  .work_outline,
                                              color: Colors
                                                  .white,
                                              size: 20),
                                        ),
                                        const SizedBox(
                                            width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                    Text(
                                                      job['title']
                                                      as String,
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize:
                                                          16,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                  // Show LIVE or DEMO tag
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                        8,
                                                        vertical:
                                                        3),
                                                    decoration:
                                                    BoxDecoration(
                                                      color: Colors
                                                          .white
                                                          .withOpacity(
                                                          0.2),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          10),
                                                    ),
                                                    child: Text(
                                                      isDemo
                                                          ? 'DEMO'
                                                          : 'LIVE',
                                                      style:
                                                      const TextStyle(
                                                        color: Colors
                                                            .white,
                                                        fontSize:
                                                        9,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '${job['positions']} position(s) open',
                                                style: TextStyle(
                                                    color: Colors
                                                        .white
                                                        .withOpacity(
                                                        0.8),
                                                    fontSize:
                                                    12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                            Icons
                                                .arrow_forward_ios_rounded,
                                            color:
                                            Colors.white,
                                            size: 16),
                                      ],
                                    ),
                                  ),

                                  // Body
                                  Padding(
                                    padding:
                                    const EdgeInsets
                                        .all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons
                                                    .schedule_rounded,
                                                color: Color(
                                                    0xFF7986CB),
                                                size: 16),
                                            const SizedBox(
                                                width: 6),
                                            Text(
                                              job['experience']
                                              as String? ??
                                                  '',
                                              style: const TextStyle(
                                                  color: Color(
                                                      0xFF7986CB),
                                                  fontSize:
                                                  13),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                            height: 12),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 6,
                                          children: skills
                                              .map((s) =>
                                              Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal:
                                                    10,
                                                    vertical:
                                                    4),
                                                decoration:
                                                BoxDecoration(
                                                  color: color
                                                      .withOpacity(
                                                      0.08),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      20),
                                                  border: Border.all(
                                                      color: color.withOpacity(
                                                          0.25)),
                                                ),
                                                child:
                                                Text(
                                                  s,
                                                  style: TextStyle(
                                                      color:
                                                      color,
                                                      fontSize:
                                                      12,
                                                      fontWeight:
                                                      FontWeight.w500),
                                                ),
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
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}