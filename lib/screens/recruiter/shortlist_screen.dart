import 'package:flutter/material.dart';
import '../../data/dummy_candidates.dart';
import '../../data/dummy_jobs.dart';

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

  void _processShortlisting() {
    List<Map<String, dynamic>> jobApplicants = selectedJob == 'All'
        ? List.from(dummyCandidates)
        : dummyCandidates
        .where((c) => c['jobTitle'] == selectedJob)
        .toList();

    jobApplicants.sort(
            (a, b) => b['resumeScore'].compareTo(a['resumeScore']));

    final count = (jobApplicants.length * 0.3).ceil();

    setState(() {
      shortlisted = jobApplicants.take(count).toList();
      others = jobApplicants.skip(count).toList();
    });
  }

  Color _resumeColor(num score) {
    if (score >= 80) return const Color(0xFF2E7D32);
    if (score >= 60) return const Color(0xFF1565C0);
    if (score >= 40) return const Color(0xFFE65100);
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
            // Dropdown
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
                      Icon(
                          job == 'All'
                              ? Icons.work_outline
                              : Icons.work_outline,
                          color: const Color(0xFF7986CB),
                          size: 18),
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

            // Stats row
            Row(
              children: [
                _statPill(
                    Icons.star_rounded,
                    '${shortlisted.length} shortlisted',
                    const Color(0xFF2E7D32),
                    const Color(0xFFE8F5E9)),
                const SizedBox(width: 10),
                _statPill(
                    Icons.people_outline,
                    '$total total',
                    const Color(0xFF3949AB),
                    const Color(0xFFE8EAF6)),
              ],
            ),
            const SizedBox(height: 20),

            // List
            Expanded(
              child: (shortlisted.isEmpty && others.isEmpty)
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3949AB)
                            .withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                          Icons.person_search_rounded,
                          color: Color(0xFF7986CB),
                          size: 40),
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
                    _sectionHeader(
                        Icons.star_rounded,
                        'Top Candidates',
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
                        Icons.people_outline,
                        'Other Candidates',
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

  Widget _statPill(
      IconData icon, String label, Color color, Color bg) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
  }

  Widget _sectionHeader(
      IconData icon, String title, Color color, Color bg) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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

  Widget _candidateCard(Map<String, dynamic> candidate, int index,
      {required bool isShortlisted}) {
    final avatarColor = _avatarColors[index % _avatarColors.length];
    final resumeScore =
    (candidate['resumeScore'] as num).toDouble();
    final scoreColor = _resumeColor(resumeScore);
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
          // Header
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
                  width: 44,
                  height: 44,
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
                      Text(candidate['name'] as String,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      Text('Applied: ${candidate['jobTitle']}',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12)),
                    ],
                  ),
                ),
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
                  ),
              ],
            ),
          ),

          // Body
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
                      borderRadius:
                      BorderRadius.circular(20),
                      border: Border.all(
                          color:
                          avatarColor.withOpacity(0.25)),
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

                // Resume score bar
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Resume Score',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9E9E9E))),
                    Text(
                        '${resumeScore.toStringAsFixed(0)}%',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: scoreColor)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: resumeScore / 100,
                    backgroundColor: Colors.grey.shade100,
                    valueColor:
                    AlwaysStoppedAnimation(scoreColor),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}