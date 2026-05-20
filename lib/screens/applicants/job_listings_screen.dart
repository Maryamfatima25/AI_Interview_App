import 'package:flutter/material.dart';
import '../../data/job_store.dart';
import '../../services/job_service.dart';
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

          // ── Search bar ───────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8)
                ],
              ),
              child: TextField(
                onChanged: (v) =>
                    setState(() => _search = v),
                style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A237E)),
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

          // ── Local recruiter posts + demo jobs + Firestore ─────────────
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: JobService.getJobsStream(),
              builder: (context, snapshot) {

                // Recruiter-created jobs live in [postedJobs] + dummy demos;
                // Firestore may also list jobs. Merge so applicants see everything.
                final remoteJobs = snapshot.hasError
                    ? <Map<String, dynamic>>[]
                    : (snapshot.data ?? <Map<String, dynamic>>[]);
                final allJobs =
                    mergeJobsForApplicantListing(remoteJobs);

                // Loading: only spin if we have nothing local to show yet
                if (snapshot.connectionState ==
                        ConnectionState.waiting &&
                    allJobs.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF3949AB)),
                  );
                }

                // Error: still show locally posted + demo jobs if any
                if (snapshot.hasError && allJobs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.red),
                      ),
                    ),
                  );
                }

                // Filter by search
                final jobs = allJobs.where((j) {
                  final title = (j['title'] ?? '').toString()
                      .toLowerCase();
                  return title.contains(
                      _search.toLowerCase());
                }).toList();

                return Column(
                  children: [

                    // Count row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            '${jobs.length} position${jobs.length != 1 ? 's' : ''} found',
                            style: const TextStyle(
                                color: Color(0xFF7986CB),
                                fontSize: 13),
                          ),
                          const Spacer(),
                          // Live indicator
                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF43A047)
                                  .withOpacity(0.1),
                              borderRadius:
                              BorderRadius.circular(
                                  20),
                            ),
                            child: const Row(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [
                                Icon(
                                    Icons
                                        .circle,
                                    color:
                                    Color(0xFF43A047),
                                    size: 8),
                                SizedBox(width: 4),
                                Text('Live',
                                    style: TextStyle(
                                        color: Color(
                                            0xFF43A047),
                                        fontSize: 11,
                                        fontWeight:
                                        FontWeight
                                            .bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Job cards
                    Expanded(
                      child: jobs.isEmpty
                          ? _emptyState()
                          : ListView.builder(
                        padding:
                        const EdgeInsets.symmetric(
                            horizontal: 16),
                        itemCount: jobs.length,
                        itemBuilder: (ctx, i) {
                          final job = jobs[i];
                          final color = _colors[
                          i % _colors.length];
                          final skills = (job['skills']
                          as List? ??
                              []).cast<String>();

                          return GestureDetector(
                            onTap: () =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        JobDetailScreen(
                                            job: job),
                                  ),
                                ),
                            child: Container(
                              margin: const EdgeInsets
                                  .only(bottom: 14),
                              decoration:
                              BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius
                                    .circular(16),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors
                                          .black
                                          .withOpacity(
                                          0.05),
                                      blurRadius: 10)
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Header
                                  Container(
                                    padding:
                                    const EdgeInsets
                                        .all(18),
                                    decoration:
                                    BoxDecoration(
                                      color: color,
                                      borderRadius:
                                      const BorderRadius
                                          .only(
                                        topLeft: Radius
                                            .circular(
                                            16),
                                        topRight: Radius
                                            .circular(
                                            16),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding:
                                          const EdgeInsets
                                              .all(
                                              10),
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
                                              size:
                                              20),
                                        ),
                                        const SizedBox(
                                            width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
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
                                            color: Colors
                                                .white,
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
                                                size:
                                                16),
                                            const SizedBox(
                                                width:
                                                6),
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
                                          runSpacing:
                                          6,
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
                                                      color: color,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500),
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

  Widget _emptyState() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.work_off_outlined,
            size: 56, color: Colors.grey),
        SizedBox(height: 16),
        Text('No jobs found',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey)),
        SizedBox(height: 8),
        Text('Check back later for new openings',
            style: TextStyle(
                fontSize: 13, color: Colors.grey)),
      ],
    ),
  );
}