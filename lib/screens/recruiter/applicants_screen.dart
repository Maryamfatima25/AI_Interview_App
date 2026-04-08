import 'package:flutter/material.dart';
import '../../data/dummy_candidates.dart';
import '../../data/dummy_jobs.dart';
import '../../data/applicant_store.dart';
import '../../models/applicant_model.dart';

class ApplicantsScreen extends StatefulWidget {
  final String? selectedJobTitle;
  const ApplicantsScreen({super.key, this.selectedJobTitle});

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  String? selectedJob;

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
  }

  // ── Merged list: real submissions first, then dummy ──────────────────────
  List<Map<String, dynamic>> get _allMerged {
    // Convert real ApplicantModel submissions → map format
    final realAsMap = submittedApplicants.map((a) => {
      'name':           a.name,
      'email':          a.email,
      'jobTitle':       a.appliedJobTitle,
      'skills':         a.skills,
      'experience':     a.experience,
      'interviewScore': a.interviewScore,
      'resumeScore':    0.0,   // no resume in new flow
      'isNew':          true,
    }).toList();

    // Tag dummy candidates so we can distinguish them
    final dummyTagged = dummyCandidates.map((c) => {
      ...c,
      'isNew': false,
    }).toList();

    return [...realAsMap, ...dummyTagged];
  }

  List<Map<String, dynamic>> get _filteredApplicants {
    final all = _allMerged;
    final filtered = (selectedJob == null || selectedJob == 'All')
        ? all
        : all.where((a) =>
    (a['jobTitle'] as String).toLowerCase() ==
        selectedJob!.toLowerCase()).toList();

    // Sort by interviewScore descending
    filtered.sort((a, b) =>
        (b['interviewScore'] as num).compareTo(a['interviewScore'] as num));
    return filtered;
  }

  void _filter(String? jobTitle) =>
      setState(() => selectedJob = jobTitle);

  Color _scoreColor(double val, {bool isPercent = false}) {
    final v = isPercent ? val / 10.0 : val;
    if (v >= 8) return const Color(0xFF2E7D32);
    if (v >= 6) return const Color(0xFF1565C0);
    if (v >= 4) return const Color(0xFFE65100);
    return const Color(0xFFC62828);
  }

  @override
  Widget build(BuildContext context) {
    final applicants = _filteredApplicants;
    final newCount = applicants.where((a) => a['isNew'] == true).length;

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

            // ── Stats bar ──────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.05), blurRadius: 8)],
              ),
              child: Row(
                children: [
                  _statPill('${applicants.length}', 'Total',
                      const Color(0xFF3949AB)),
                  const SizedBox(width: 10),
                  _statPill(
                    '${applicants.where((a) =>
                    (a['interviewScore'] as num) >= 7).length}',
                    'Strong',
                    const Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 10),
                  _statPill('$newCount', 'New',
                      const Color(0xFFE65100)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Filter dropdown ────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.05), blurRadius: 8)],
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
                      ]),
                    ),
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
            const SizedBox(height: 12),

            // Count row
            Row(
              children: [
                const Icon(Icons.people_outline,
                    color: Color(0xFF7986CB), size: 16),
                const SizedBox(width: 6),
                Text(
                  '${applicants.length} applicant${applicants.length == 1 ? '' : 's'} found',
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF7986CB)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── List ───────────────────────────────────────────────────────
            Expanded(
              child: applicants.isEmpty
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
                            fontSize: 13, color: Color(0xFF9E9E9E))),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: applicants.length,
                itemBuilder: (context, index) =>
                    _buildCard(applicants[index], index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> applicant, int index) {
    final avatarColor = _avatarColors[index % _avatarColors.length];
    final interviewScore = (applicant['interviewScore'] as num).toDouble();
    final resumeScore = (applicant['resumeScore'] as num).toDouble();
    final isNew = applicant['isNew'] == true;
    final initials = (applicant['name'] as String)
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    // Job skills for highlighting matched chips
    final jobSkills = selectedJob != null && selectedJob != 'All'
        ? (dummyJobs.firstWhere(
            (j) => j['title'] == selectedJob,
        orElse: () => {'skills': <String>[]})['skills'] as List)
        .map((s) => s.toString().toLowerCase())
        .toList()
        : <String>[];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isNew
            ? Border.all(
            color: const Color(0xFF3949AB).withOpacity(0.4),
            width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          // ── Colored header ───────────────────────────────────────────────
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
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(applicant['name'] as String,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          if (isNew) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('NEW',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      Text('Applied for: ${applicant['jobTitle']}',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12)),
                    ],
                  ),
                ),
                // Interview score badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      interviewScore.toStringAsFixed(1),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text('/ 10',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skills with match highlighting
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (applicant['skills'] as List<dynamic>)
                      .cast<String>()
                      .map((s) {
                    final isMatch =
                    jobSkills.contains(s.toLowerCase());
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isMatch
                            ? const Color(0xFFE8F5E9)
                            : avatarColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isMatch
                              ? const Color(0xFF43A047).withOpacity(0.4)
                              : avatarColor.withOpacity(0.25),
                        ),
                      ),
                      child: Text(s,
                          style: TextStyle(
                              color: isMatch
                                  ? const Color(0xFF2E7D32)
                                  : avatarColor,
                              fontSize: 11,
                              fontWeight: isMatch
                                  ? FontWeight.w600
                                  : FontWeight.w500)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 14),

                // Scores row
                Row(
                  children: [
                    // Only show resume score for dummy candidates
                    if (!isNew) ...[
                      Expanded(
                        child: _scoreWidget('Resume Match', resumeScore,
                            100, const Color(0xFF00897B)),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: _scoreWidget('AI Interview',
                          interviewScore, 10, const Color(0xFF3949AB)),
                    ),
                  ],
                ),

                // Experience if available
                if ((applicant['experience'] ?? '').toString().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.schedule_outlined,
                          size: 13, color: Color(0xFF9E9E9E)),
                      const SizedBox(width: 5),
                      Text(applicant['experience'] as String,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF9E9E9E))),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
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
            Text('${value.toStringAsFixed(1)}/${max.toStringAsFixed(0)}',
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

  Widget _statPill(String value, String label, Color color) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14)),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    color: color.withOpacity(0.8), fontSize: 11)),
          ],
        ),
      );
}