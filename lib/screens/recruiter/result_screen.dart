import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Dummy data
    List<Map<String, dynamic>> candidates = [
      {"name": "Ali", "resumeScore": 85, "interviewScore": 8.5},
      {"name": "Sara", "resumeScore": 80, "interviewScore": 7.9},
      {"name": "Ahmed", "resumeScore": 40, "interviewScore": 6.2},
    ];

    // 🔹 Calculate final score and sort
    candidates.forEach((c) {
      c['finalScore'] = (c['resumeScore'] * 0.4 / 10) + c['interviewScore'] * 0.6;
      // ResumeScore normalized to 10 scale: 0-100 → 0-10
    });

    candidates.sort((a, b) => (b['finalScore'] as double).compareTo(a['finalScore'] as double));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Final Results"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: candidates.length,
          itemBuilder: (context, index) {
            final candidate = candidates[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Candidate Name & Rank
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${index + 1}. ${candidate['name']}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Score: ${candidate['finalScore'].toStringAsFixed(1)}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Resume Score
                    Text("Resume Match: ${candidate['resumeScore']}%"),
                    LinearProgressIndicator(
                      value: candidate['resumeScore'] / 100,
                      backgroundColor: Colors.grey[200],
                      color: Colors.blue,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 6),

                    // Interview Score
                    Text("Interview Score: ${candidate['interviewScore']} / 10"),
                    LinearProgressIndicator(
                      value: candidate['interviewScore'] / 10,
                      backgroundColor: Colors.grey[200],
                      color: Colors.green,
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