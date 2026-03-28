import 'package:flutter/material.dart';

class InterviewScreen extends StatefulWidget {
  final List<Map<String, dynamic>> shortlistedCandidates;

  const InterviewScreen({super.key, required this.shortlistedCandidates});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  int current = 0;
  final Map<String, double> interviewScores = {};

  final List<String> questions = [
    "Explain your most recent project?",
    "What is your strength in programming?",
    "Why do you want to join this company?",
  ];

  final TextEditingController answerController = TextEditingController();
  final TextEditingController scoreController = TextEditingController();

  void nextCandidate() {
    final candidateName = widget.shortlistedCandidates[current]['name'];
    final score = double.tryParse(scoreController.text) ?? 0;
    interviewScores[candidateName] = score;

    if (current + 1 < widget.shortlistedCandidates.length) {
      setState(() {
        current++;
        answerController.clear();
        scoreController.clear();
      });
    } else {
      Navigator.pop(context, interviewScores); // back to Results
    }
  }

  @override
  Widget build(BuildContext context) {
    final candidate = widget.shortlistedCandidates[current];
    return Scaffold(
      appBar: AppBar(
        title: Text("Interview: ${candidate['name']}"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Question: ${questions[current % questions.length]}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: answerController,
              maxLines: 3,
              decoration: const InputDecoration(
                  hintText: "Type candidate answer here",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: scoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: "Score (1-10)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: nextCandidate,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
              child: Text(current + 1 < widget.shortlistedCandidates.length
                  ? "Next Candidate"
                  : "Finish Interviews"),
            )
          ],
        ),
      ),
    );
  }
}