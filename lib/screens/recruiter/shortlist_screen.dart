import 'package:flutter/material.dart';
import '../../data/dummy_candidates.dart';
import '../../data/dummy_jobs.dart';
import '../../data/applicant_store.dart';

class ShortlistScreen extends StatefulWidget {
  const ShortlistScreen({super.key});

  @override
  State<ShortlistScreen> createState() => _ShortlistScreenState();
}

class _ShortlistScreenState extends State<ShortlistScreen> {
  String selectedJob = 'All';
  List<Map<String, dynamic>> shortlisted = [];
  List<Map<String, dynamic>> others = [];

  final List<Color> _avatarColors = [
    const Color(0xFF3949AB),
    const Color(0xFF00897B),
    const Color(0xFF7E57C2),
    const Color(0xFFEF6C00),
  ];

  @override
  void initState() {
    super.initState();
    _processShortlisting();
  }

  // ── Merged real + dummy candidates ────────────────────────────────────────
  List<Map<String, dynamic>> get _allMerged {
    final realAsMap = submittedApplicants.map((a) => {
      'name':           a.name,
      'email':          a.email,
      'jobTitle':       a.appliedJobTitle,
      'skills':         a.skills,
      'experience':     a.experience,
      'interviewScore': a.interviewScore,
      'resumeScore':    0.0,
      'isNew':          true,
    }).toList();

    final dummyTagged = dummyCandidates.map((c) => {
      ...c,
      'isNew': false,
    }).toList();

    return [...realAsMap, ...dummyTagged];
  }

  void _processShortlisting() {
    // Filter by selected job
    List<Map<String, dynamic>> jobApplicants = selectedJob == 'All'
        ? List.from(_allMerged)
        : _allMerged
        .where((c) =>
    (c['jobTitle'] as String).toLowerCase() ==
        selectedJob.toLowerCase())
        .toList();

    // Sort by interviewScore descending (real applicants)
    // fallback to resumeScore for dummy candidates
    jobApplicants.sort((a, b) {
      final aScore = (a['interviewScore'] as num) > 0
          ? (a['interviewScore'] as num)
          : (a['resumeScore'] as num) / 10;
      final bScore = (b['interviewScore'] as num) > 0
          ? (b['interviewScore'] as num)
          : (b['resumeScore'] as num) / 10;
      return bScore.compareTo(aScore);
    });

    // Top 30% are shortlisted
    final count = (jobApplicants.length * 0.3).ceil();

    setState(() {
      shortlisted = jobApplicants.take(count).toList();
      others      = jobApplicants.skip(count).toList();
    });
  }

  Color _scoreColor(num score, {bool isInterview = false}) {
    final v = isInterview ? score.toDouble() : score / 10.0;
    if (v >= 8) return const Color(0xFF2E7D32);
    if (v >= 6) return const Color(0xFF1565C0);
    if (v >= 4) return const Color(0xFFE65100);
    return const Color(0xFFC62828);
  }

  @override
  Widget build(BuildContext context) {
    final jobTitles = [
      'All',
      ...dummyJobs.map((j) => j['title'] as String),
    ];
    final total = shortlisted.length + others.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Shortlisted Candidates',
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

            // ── Job filter dropdown ───────────────────────────────────────
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
                  value: selectedJob,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF7986CB)),
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF1A237E)),
                  items: jobTitles
                      .map((job) => DropdownMenuItem(
                    value: job,
                    child: Row(children: [
                      const Icon(Icons.work_outline,
                          color: Color(0xFF7986CB), size: 18),
                      const SizedBox(width: 10),
                      Text(job == 'All' ? 'All Jobs' : job),
                    ]),
                  ))
                      .toList(),
                  onChanged: (v) {
                    setState(() => selectedJob = v!);
                    _processShortlisting();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Stats row ─────────────────────────────────────────────────
            Row(
              children: [
                _statPill(Icons.star_rounded,
                    '${shortlisted.length} shortlisted',
                    const Color(0xFF2E7D32), const Color(0xFFE8F5E9)),
                const SizedBox(width: 10),
                _statPill(Icons.people_outline, '$total total',
                    const Color(0xFF3949AB), const Color(0xFFE8EAF6)),
                const SizedBox(width: 10),
                // New real applicants badge
                if (submittedApplicants.isNotEmpty)
                  _statPill(Icons.fiber_new_rounded,
                      '${submittedApplicants.length} new',
                      const Color(0xFFE65100),
                      const Color(0xFFFFF3E0)),
              ],
            ),
            const SizedBox(height: 20),

            // ── List ──────────────────────────────────────────────────────
            Expanded(
              child: (shortlisted.isEmpty && others.isEmpty)
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
                  ],
                ),
              )
                  : ListView(
                children: [
                  if (shortlisted.isNotEmpty) ...[
                    _sectionHeader(Icons.star_rounded, 'Top Candidates',
                        const Color(0xFF2E7D32),
                        const Color(0xFFE8F5E9)),
                    const SizedBox(height: 12),
                    ...shortlisted.asMap().entries.map((e) =>
                        _candidateCard(e.value, e.key,
                            isShortlisted: true)),
                    const SizedBox(height: 20),
                  ],
                  if (others.isNotEmpty) ...[
                    _sectionHeader(
                        Icons.people_outline, 'Other Candidates',
                        const Color(0xFF546E7A),
                        const Color(0xFFECEFF1)),
                    const SizedBox(height: 12),
                    ...others.asMap().entries.map((e) =>
                        _candidateCard(e.value, e.key,
                            isShortlisted: false)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _candidateCard(Map<String, dynamic> candidate, int index,
      {required bool isShortlisted}) {
    final avatarColor    = _avatarColors[index % _avatarColors.length];
    final isNew          = candidate['isNew'] == true;
    final interviewScore = (candidate['interviewScore'] as num).toDouble();
    final resumeScore    = (candidate['resumeScore'] as num).toDouble();

    // Display score: interview score for real, resume score for dummy
    final displayScore   = isNew ? interviewScore : resumeScore;
    final isInterviewBased = isNew;
    final scoreColor     = _scoreColor(displayScore,
        isInterview: isInterviewBased);

    final initials = (candidate['name'] as String)
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
        border: isShortlisted
            ? Border.all(
            color: const Color(0xFF43A047).withOpacity(0.4),
            width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
              color: isShortlisted
                  ? const Color(0xFF43A047).withOpacity(0.08)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isShortlisted
                  ? const Color(0xFF2E7D32)
                  : avatarColor,
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
                          Flexible(
                            child: Text(candidate['name'] as String,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                          // NEW badge for real applicants
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
                      Text('Applied: ${candidate['jobTitle']}',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12)),
                    ],
                  ),
                ),
                // Shortlisted badge OR score
                if (isShortlisted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded,
                            color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text('Shortlisted',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isInterviewBased
                            ? displayScore.toStringAsFixed(1)
                            : '${displayScore.toStringAsFixed(0)}%',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        isInterviewBased ? '/ 10' : 'match',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // ── Body ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skills
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (candidate['skills'] as List<dynamic>)
                      .cast<String>()
                      .map((s) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: avatarColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: avatarColor.withOpacity(0.25)),
                    ),
                    child: Text(s,
                        style: TextStyle(
                            color: avatarColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 14),

                // Score bar — interview for real, resume for dummy
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isInterviewBased ? 'AI Interview Score' : 'Resume Score',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF9E9E9E)),
                    ),
                    Text(
                      isInterviewBased
                          ? '${displayScore.toStringAsFixed(1)} / 10'
                          : '${displayScore.toStringAsFixed(0)}%',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: scoreColor),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: isInterviewBased
                        ? displayScore / 10
                        : displayScore / 100,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation(scoreColor),
                    minHeight: 8,
                  ),
                ),

                // Experience for real applicants
                if (isNew &&
                    (candidate['experience'] ?? '').toString().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.schedule_outlined,
                          size: 13, color: Color(0xFF9E9E9E)),
                      const SizedBox(width: 5),
                      Text(candidate['experience'] as String,
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

  Widget _statPill(IconData icon, String label, Color color, Color bg) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color)),
          ],
        ),
      );

  Widget _sectionHeader(
      IconData icon, String title, Color color, Color bg) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
      );
}