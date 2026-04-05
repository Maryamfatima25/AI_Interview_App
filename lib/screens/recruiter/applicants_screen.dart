import 'package:flutter/material.dart';
import '../../data/dummy_candidates.dart';
import '../../data/dummy_jobs.dart';

class ApplicantsScreen extends StatefulWidget {
  final String? selectedJobTitle;
  const ApplicantsScreen({super.key, this.selectedJobTitle});

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  String? selectedJob;
  List<Map<String, dynamic>> filteredApplicants = [];

  final List<Color> _avatarColors = [
    const Color(0xFF3949AB),
    const Color(0xFF00897B),
    const Color(0xFF7E57C2),
    const Color(0xFFEF6C00),
  ];

  @override
  void initState() {
    super.initState();
    selectedJob = widget.selectedJobTitle ?? 'All';
    filteredApplicants = dummyCandidates;
    if (widget.selectedJobTitle != null) {
      _filter(widget.selectedJobTitle);
    }
  }

  void _filter(String? jobTitle) {
    setState(() {
      selectedJob = jobTitle;
      filteredApplicants =
      (jobTitle == null || jobTitle == 'All')
          ? dummyCandidates
          : dummyCandidates
          .where((a) => a['jobTitle'] == jobTitle)
          .toList();
    });
  }

  Color _scoreColor(num score, {bool isPercent = false}) {
    final val = isPercent ? score / 10.0 : score.toDouble();
    if (val >= 8) return const Color(0xFF2E7D32);
    if (val >= 6) return const Color(0xFF1565C0);
    if (val >= 4) return const Color(0xFFE65100);
    return const Color(0xFFC62828);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Applicants',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF3949AB)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter dropdown
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8)
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedJob ?? 'All',
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF7986CB)),
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF1A237E)),
                  items: [
                    const DropdownMenuItem(
                        value: 'All',
                        child: Row(children: [
                          Icon(Icons.work_outline,
                              color: Color(0xFF7986CB), size: 18),
                          SizedBox(width: 10),
                          Text('All Jobs'),
                        ])),
                    ...dummyJobs.map((job) => DropdownMenuItem(
                      value: job['title'] as String,
                      child: Row(children: [
                        const Icon(Icons.work_outline,
                            color: Color(0xFF7986CB), size: 18),
                        const SizedBox(width: 10),
                        Text(job['title'] as String),
                      ]),
                    )),
                  ],
                  onChanged: _filter,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Count row
            Row(
              children: [
                const Icon(Icons.people_outline,
                    color: Color(0xFF7986CB), size: 16),
                const SizedBox(width: 6),
                Text(
                  '${filteredApplicants.length} applicant${filteredApplicants.length == 1 ? '' : 's'} found',
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF7986CB)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // List
            Expanded(
              child: filteredApplicants.isEmpty
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
                      child: const Icon(Icons.person_search_rounded,
                          color: Color(0xFF7986CB), size: 40),
                    ),
                    const SizedBox(height: 16),
                    const Text('No applicants found',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF37474F))),
                    const SizedBox(height: 6),
                    const Text('Try selecting a different job filter',
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9E9E9E))),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: filteredApplicants.length,
                itemBuilder: (context, index) {
                  final applicant = filteredApplicants[index];
                  final avatarColor =
                  _avatarColors[index % _avatarColors.length];
                  final interviewScore =
                  (applicant['interviewScore'] as num).toDouble();
                  final resumeScore =
                  (applicant['resumeScore'] as num).toDouble();
                  final initials = (applicant['name'] as String)
                      .split(' ')
                      .map((e) => e.isNotEmpty ? e[0] : '')
                      .take(2)
                      .join()
                      .toUpperCase();

                  return Container(
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
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: avatarColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color:
                                  Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(initials,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(applicant['name'] as String,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.bold)),
                                    Text(
                                        'Applied for: ${applicant['jobTitle']}',
                                        style: TextStyle(
                                            color: Colors.white
                                                .withOpacity(0.8),
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
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
                              // Skills
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: (applicant['skills']
                                as List<dynamic>)
                                    .cast<String>()
                                    .map((s) => Container(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4),
                                  decoration: BoxDecoration(
                                    color: avatarColor
                                        .withOpacity(0.08),
                                    borderRadius:
                                    BorderRadius.circular(
                                        20),
                                    border: Border.all(
                                        color: avatarColor
                                            .withOpacity(0.25)),
                                  ),
                                  child: Text(s,
                                      style: TextStyle(
                                          color: avatarColor,
                                          fontSize: 11,
                                          fontWeight:
                                          FontWeight.w500)),
                                ))
                                    .toList(),
                              ),
                              const SizedBox(height: 16),
                              const Divider(height: 1),
                              const SizedBox(height: 14),

                              // Scores
                              Row(
                                children: [
                                  Expanded(
                                      child: _scoreWidget(
                                          'Resume Match',
                                          resumeScore,
                                          100,
                                          const Color(0xFF00897B))),
                                  const SizedBox(width: 16),
                                  Expanded(
                                      child: _scoreWidget(
                                          'Interview',
                                          interviewScore,
                                          10,
                                          const Color(0xFF3949AB))),
                                ],
                              ),
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
      ),
    );
  }

  Widget _scoreWidget(
      String label, double value, double max, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF9E9E9E))),
            Text(
                '${value.toStringAsFixed(1)}/${max.toStringAsFixed(0)}',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value / max,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}