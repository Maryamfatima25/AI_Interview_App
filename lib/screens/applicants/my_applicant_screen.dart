import 'package:flutter/material.dart';
import '../../models/applicant_model.dart';
import '../../data/applicant_store.dart';

class MyApplicationsScreen extends StatelessWidget {
  const MyApplicationsScreen({super.key});

  Color _matchColor(double score) {
    if (score >= 70) return const Color(0xFF2E7D32);
    if (score >= 40) return const Color(0xFFE65100);
    return const Color(0xFFC62828);
  }

  Color _cardColor(int index) {
    final colors = [
      const Color(0xFF3949AB),
      const Color(0xFF00897B),
      const Color(0xFF7E57C2),
      const Color(0xFFEF6C00),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final applications = submittedApplicants
        .where((a) => a.email == currentApplicant.email)
        .map((a) => {
      'title':          a.appliedJobTitle,
      'skills':         a.skills,
      'experience':     a.experience,
      'interviewScore': a.interviewScore,
      'status':         'Under Review',
      'appliedOn':      '',
      'positions':      '1',
      'matchScore':     0.0,
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text(
          'My Applications',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E)),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF3949AB)),
      ),
      body: applications.isEmpty
          ? _emptyState(context)
          : Column(
        children: [
          // ── Summary bar ──────────────────────────
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3949AB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.send_rounded,
                    color: Colors.white70, size: 20),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${applications.length} Application${applications.length > 1 ? 's' : ''} Submitted',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    const Text(
                      'Recruiter will review and contact you',
                      style: TextStyle(
                          color: Color(0xFFB3BCF5),
                          fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Applications list ────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16),
              itemCount: applications.length,
              itemBuilder: (ctx, i) {
                final app = applications[i];
                final color = _cardColor(i);
                final matchScore =
                    (app['matchScore'] as num?)
                        ?.toDouble() ??
                        0.0;
                final matchColor =
                _matchColor(matchScore);
                final skills =
                (app['skills'] as List? ?? [])
                    .cast<String>();
                final appliedOn =
                    app['appliedOn'] as String? ?? '';
                final status =
                    app['status'] as String? ??
                        'Under Review';

                // Parse date nicely
                String dateStr = '';
                if (appliedOn.isNotEmpty) {
                  try {
                    final dt =
                    DateTime.parse(appliedOn);
                    dateStr =
                    '${dt.day}/${dt.month}/${dt.year}';
                  } catch (_) {
                    dateStr = 'Recently';
                  }
                }

                return Container(
                  margin:
                  const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black
                              .withOpacity(0.05),
                          blurRadius: 10)
                    ],
                  ),
                  child: Column(
                    children: [
                      // Colored header
                      Container(
                        padding:
                        const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius:
                          const BorderRadius.only(
                            topLeft:
                            Radius.circular(16),
                            topRight:
                            Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding:
                              const EdgeInsets.all(
                                  8),
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withOpacity(0.2),
                                borderRadius:
                                BorderRadius
                                    .circular(8),
                              ),
                              child: const Icon(
                                  Icons.work_outline,
                                  color: Colors.white,
                                  size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Text(
                                    app['title']
                                    as String? ??
                                        '',
                                    style: const TextStyle(
                                        color:
                                        Colors.white,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        fontSize: 15),
                                  ),
                                  if (dateStr
                                      .isNotEmpty)
                                    Text(
                                      'Applied on $dateStr',
                                      style: TextStyle(
                                          color: Colors
                                              .white
                                              .withOpacity(
                                              0.8),
                                          fontSize: 11),
                                    ),
                                ],
                              ),
                            ),
                            // Status badge
                            Container(
                              padding: const EdgeInsets
                                  .symmetric(
                                  horizontal: 10,
                                  vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withOpacity(0.2),
                                borderRadius:
                                BorderRadius
                                    .circular(20),
                              ),
                              child: Text(
                                status,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Card body
                      Padding(
                        padding:
                        const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            // Match score bar
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                const Text(
                                    'Skill match',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                        Colors.grey)),
                                Text(
                                  '${matchScore.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                      FontWeight.bold,
                                      color: matchColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius:
                              BorderRadius.circular(
                                  4),
                              child:
                              LinearProgressIndicator(
                                value: matchScore / 100,
                                backgroundColor:
                                Colors.grey.shade100,
                                valueColor:
                                AlwaysStoppedAnimation(
                                    matchColor),
                                minHeight: 7,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Experience + positions
                            Row(
                              children: [
                                _infoChip(
                                    Icons
                                        .schedule_outlined,
                                    app['experience']
                                    as String? ??
                                        ''),
                                const SizedBox(width: 12),
                                _infoChip(
                                    Icons.people_outline,
                                    '${app['positions'] ?? 1} position(s)'),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Skills
                            if (skills.isNotEmpty)
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: skills
                                    .map((s) => Container(
                                  padding: const EdgeInsets
                                      .symmetric(
                                      horizontal:
                                      10,
                                      vertical: 4),
                                  decoration:
                                  BoxDecoration(
                                    color: color
                                        .withOpacity(
                                        0.08),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        20),
                                    border: Border.all(
                                        color: color
                                            .withOpacity(
                                            0.2)),
                                  ),
                                  child: Text(s,
                                      style: TextStyle(
                                          fontSize:
                                          11,
                                          color:
                                          color,
                                          fontWeight:
                                          FontWeight
                                              .w500)),
                                ))
                                    .toList(),
                              ),

                            // Interview score if done
                            if (currentApplicant
                                .interviewScore >
                                0) ...[
                              const SizedBox(height: 12),
                              const Divider(height: 1),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                      Icons
                                          .smart_toy_outlined,
                                      size: 16,
                                      color: Color(
                                          0xFF7E57C2)),
                                  const SizedBox(
                                      width: 6),
                                  const Text(
                                      'AI Interview Score: ',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(
                                              0xFF7E57C2))),
                                  Text(
                                    '${currentApplicant.interviewScore.toStringAsFixed(1)} / 10',
                                    style: const TextStyle(
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        color: Color(
                                            0xFF7E57C2),
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: Colors.grey),
      const SizedBox(width: 4),
      Text(label,
          style: const TextStyle(
              fontSize: 12, color: Colors.grey)),
    ],
  );

  Widget _emptyState(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_outlined,
            size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 20),
        const Text("No applications yet",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey)),
        const SizedBox(height: 8),
        const Text(
          "Browse jobs and apply to see\nyour applications here",
          textAlign: TextAlign.center,
          style:
          TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3949AB),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Browse Jobs',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}