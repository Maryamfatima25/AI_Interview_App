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
  List<Map<String, dynamic>> rankedCandidates = [];

  @override
  void initState() {
    super.initState();
    _processRanking();
  }

  List<Map<String, dynamic>> get _allMerged {
    final realAsMap = submittedApplicants.map((a) => {
      'name':           a.name,
      'email':          a.email,
      'jobTitle':       a.appliedJobTitle,
      'skills':         a.skills,
      'experience':     a.experience,
      'interviewScore': a.interviewScore, // 0-10
      'resumeScore':    a.resumeMatchScore, // 0-100
      'isNew':          true,
    }).toList();

    final dummyTagged = dummyCandidates.map((c) => {
      ...c,
      'isNew': false,
      'resumeScore': (c['resumeScore'] ?? 0.0),
      'interviewScore': (c['interviewScore'] ?? 0.0),
    }).toList();

    return [...realAsMap, ...dummyTagged];
  }

  void _processRanking() {
    List<Map<String, dynamic>> filtered = selectedJob == 'All'
        ? List.from(_allMerged)
        : _allMerged.where((c) => (c['jobTitle'] as String).toLowerCase() == selectedJob.toLowerCase()).toList();

    // ── ACCUMULATED SCORE CALCULATION ─────────────────────────
    for (var c in filtered) {
      final resume = (c['resumeScore'] as num).toDouble();
      final interview = (c['interviewScore'] as num).toDouble() * 10; // scale 0-10 to 0-100
      c['accumulatedScore'] = (resume * 0.4) + (interview * 0.6); // 40% resume, 60% interview
    }

    // Sort in ASCENDING order as requested (lowest score first)
    filtered.sort((a, b) => (a['accumulatedScore'] as double).compareTo(b['accumulatedScore'] as double));

    setState(() {
      rankedCandidates = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobTitles = ['All', ...dummyJobs.map((j) => j['title'] as String)];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(title: const Text('Ranked Candidates (Ascending)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedJob,
              isExpanded: true,
              items: jobTitles.map((j) => DropdownMenuItem(value: j, child: Text(j))).toList(),
              onChanged: (v) {
                setState(() => selectedJob = v!);
                _processRanking();
              },
            ),
          ),
          Expanded(
            child: rankedCandidates.isEmpty 
              ? const Center(child: Text('No applicants found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: rankedCandidates.length,
                  itemBuilder: (ctx, i) => _candidateCard(rankedCandidates[i], i),
                ),
          ),
        ],
      ),
    );
  }

  Widget _candidateCard(Map<String, dynamic> c, int index) {
    final accScore = (c['accumulatedScore'] as double).toStringAsFixed(1);
    final resScore = (c['resumeScore'] as num).toStringAsFixed(0);
    final intScore = (c['interviewScore'] as num).toStringAsFixed(1);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(c['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Job: ${c['jobTitle']}'),
            Text('Resume Match: $resScore% | AI Interview: $intScore/10'),
            Text('Accumulated: $accScore', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          ],
        ),
        trailing: Wrap(
          children: [
            IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () {}),
            IconButton(icon: const Icon(Icons.calendar_today, color: Colors.blue), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
