import 'package:flutter/material.dart';
import '../../data/dummy_candidates.dart';

class ApplicantsScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const ApplicantsScreen({super.key, required this.job});

  double calculateMatchScore(List<String> jobSkills, List<String> candidateSkills) {
    int matches = candidateSkills.where((skill) => jobSkills.contains(skill)).length;
    return (matches / jobSkills.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    // Add matchScore dynamically
    List<Map<String, dynamic>> candidatesWithScore = dummyCandidates.map((c) {
      double score = calculateMatchScore(job['skills'], c['skills']);
      return {...c, 'matchScore': score};
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Applicants for ${job['title']}"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: candidatesWithScore.length,
          itemBuilder: (context, index) {
            final candidate = candidatesWithScore[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                title: Text(candidate['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text("Skills: ${candidate['skills'].join(', ')}"),
                    const SizedBox(height: 5),
                    Text("Match Score: ${candidate['matchScore'].toStringAsFixed(0)}%"),
                    const SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: candidate['matchScore'] / 100,
                      color: Colors.blue,
                      backgroundColor: Colors.grey[300],
                      minHeight: 8,
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Later: navigate to Shortlist or Interview page
                },
              ),
            );
          },
        ),
      ),
    );
  }
}