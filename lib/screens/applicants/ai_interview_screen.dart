import 'package:flutter/material.dart';
import '../../data/dummy_questions.dart';
import '../../models/applicant_model.dart';
import 'interview_result_screen.dart';

class AiInterviewScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  const AiInterviewScreen({super.key, required this.job});

  @override
  State<AiInterviewScreen> createState() => _AiInterviewScreenState();
}

class _AiInterviewScreenState extends State<AiInterviewScreen> {
  late List<InterviewQuestion> _questions;
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    final title = widget.job['title'] as String;
    
    // Logic: Look for questions matching the job tech stack
    // Default to generic if no match found
    List<InterviewQuestion>? pool;
    
    // Check for direct match or category match
    if (interviewQuestions.containsKey(title)) {
      pool = List.from(interviewQuestions[title]!);
    } else {
      // Search for keyword matches (e.g. if job title is "Senior Flutter Developer" it should match "Mobile Developer")
      final lowerTitle = title.toLowerCase();
      if (lowerTitle.contains('flutter') || lowerTitle.contains('mobile') || lowerTitle.contains('android') || lowerTitle.contains('ios')) {
        pool = List.from(interviewQuestions['Mobile Developer'] ?? []);
      } else if (lowerTitle.contains('react') || lowerTitle.contains('frontend')) {
        pool = List.from(interviewQuestions['Frontend Developer'] ?? []);
      } else if (lowerTitle.contains('python') || lowerTitle.contains('backend') || lowerTitle.contains('node')) {
        pool = List.from(interviewQuestions['Backend Developer'] ?? []);
      }
    }

    pool ??= List.from(genericQuestions);
    pool.shuffle();
    _questions = pool.take(5).toList();
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == _questions[_currentIndex].correctIndex) {
        _correctCount++;
      }
    });
  }

  void _next() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
    } else {
      final score = (_correctCount / _questions.length) * 10;
      currentApplicant.interviewScore = score;
      currentApplicant.aiVerdict = score >= 7 ? 'Excellent' : (score >= 5 ? 'Good' : 'Needs Improvement');

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const InterviewResultScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return const Scaffold(body: Center(child: Text('No questions available')));
    
    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(title: Text('Interview: ${widget.job['title']}')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            LinearProgressIndicator(value: (_currentIndex + 1) / _questions.length),
            const SizedBox(height: 32),
            Text('Question ${_currentIndex + 1} of ${_questions.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(q.question, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(q.options.length, (index) => _optionButton(index, q.options[index])),
            const Spacer(),
            if (_answered) 
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _next, child: const Text('Next')),
              ),
          ],
        ),
      ),
    );
  }

  Widget _optionButton(int index, String text) {
    Color color = Colors.white;
    if (_answered) {
      if (index == _questions[_currentIndex].correctIndex) color = Colors.green.shade100;
      else if (index == _selectedAnswer) color = Colors.red.shade100;
    }

    return GestureDetector(
      onTap: () => _selectAnswer(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 12, child: Text(String.fromCharCode(65 + index), style: const TextStyle(fontSize: 12))),
            const SizedBox(width: 12),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}
