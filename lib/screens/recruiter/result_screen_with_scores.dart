import 'package:flutter/material.dart';
import '../../data/dummy_candidates.dart';

class ResultScreenWithScores extends StatelessWidget {
  final Map<String, dynamic> job;
  final Map<String, double> interviewScores;

  const ResultScreenWithScores(
      {super.key, required this.job, required this.interviewScores});

  @override
  Widget build(BuildContext context) {
    // Prepare candidates with final score
    List<Map<String, dynamic>> candidates = dummyCandidates
        .where((c) => interviewScores.keys.contains(c['name']))
        .map((c) {
      double interviewScore = interviewScores[c['name']]!;
      double resumeScore = c['skills']
          .where((skill) => job['skills'].contains(skill))
          .length /
          job['skills'].length *
          100;
      double finalScore = (resumeScore * 0.4 / 10) + (interviewScore * 0.6);
      return {...c, 'resumeScore': resumeScore, 'interviewScore': interviewScore, 'finalScore': finalScore};
    }).toList();

    candidates.sort((a, b) => (b['finalScore'] as double)
        .compareTo(a['finalScore'] as double));

    return Scaffold(
      appBar: AppBar(title: Text("Results: ${job['title']}"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: candidates.length,
          itemBuilder: (context, index) {
            final candidate = candidates[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Candidate Name + Final Score
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${index + 1}. ${candidate['name']}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Score: ${candidate['finalScore'].toStringAsFixed(1)}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                        "Resume Match: ${candidate['resumeScore'].toStringAsFixed(0)}%"),
                    LinearProgressIndicator(
                      value: candidate['resumeScore'] / 100,
                      color: Colors.blue,
                      backgroundColor: Colors.grey[300],
                      minHeight: 8,
                    ),
                    const SizedBox(height: 6),
                    Text(
                        "Interview Score: ${candidate['interviewScore'].toStringAsFixed(1)} / 10"),
                    LinearProgressIndicator(
                      value: candidate['interviewScore'] / 10,
                      color: Colors.green,
                      backgroundColor: Colors.grey[300],
                      minHeight: 8,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}