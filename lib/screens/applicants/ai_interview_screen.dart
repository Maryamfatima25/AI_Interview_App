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
  final List<bool> _results = [];

  @override
  void initState() {
    super.initState();
    final title = widget.job['title'] as String;
    _questions = interviewQuestions[title] ?? genericQuestions;
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == _questions[_currentIndex].correctIndex) {
        _correctCount++;
        _results.add(true);
      } else {
        _results.add(false);
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
      // Calculate score out of 10
      final score = (_correctCount / _questions.length) * 10;
      currentApplicant.interviewScore = score;

      // AI verdict
      String verdict;
      if (score >= 8) {
        verdict = 'Excellent performance! You are a strong candidate.';
      } else if (score >= 6) {
        verdict = 'Good performance. You have solid fundamentals.';
      } else if (score >= 4) {
        verdict = 'Average performance. Some areas need improvement.';
      } else {
        verdict = 'Below expectations. We encourage further preparation.';
      }
      currentApplicant.aiVerdict = verdict;

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const InterviewResultScreen()));
    }
  }

  Color _optionColor(int index) {
    if (!_answered) return Colors.white;
    if (index == _questions[_currentIndex].correctIndex) return const Color(0xFFE8F5E9);
    if (index == _selectedAnswer) return const Color(0xFFFFEBEE);
    return Colors.white;
  }

  Color _optionBorder(int index) {
    if (!_answered) {
      return index == _selectedAnswer
          ? const Color(0xFF3949AB)
          : Colors.transparent;
    }
    if (index == _questions[_currentIndex].correctIndex) return const Color(0xFF43A047);
    if (index == _selectedAnswer) return const Color(0xFFE53935);
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3949AB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.smart_toy_outlined,
                        color: Color(0xFF3949AB), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('AI Interview',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E))),
                      Text(widget.job['title'] as String,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF7986CB))),
                    ],
                  ),
                  const Spacer(),
                  Text('${_currentIndex + 1}/${_questions.length}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold,
                          color: Color(0xFF3949AB))),
                ],
              ),
              const SizedBox(height: 20),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF3949AB)),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 6),

              // Answer dots
              Row(
                children: List.generate(_questions.length, (i) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 4,
                    decoration: BoxDecoration(
                      color: i < _results.length
                          ? (_results[i] ? const Color(0xFF43A047) : const Color(0xFFE53935))
                          : i == _currentIndex
                          ? const Color(0xFF3949AB).withOpacity(0.3)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 28),

              // Question card
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3949AB),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFF3949AB).withOpacity(0.25),
                                blurRadius: 20, offset: const Offset(0, 8))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('Question ${_currentIndex + 1}',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                            ),
                            const SizedBox(height: 14),
                            Text(q.question,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Options
                      ...List.generate(q.options.length, (i) {
                        final isCorrect = _answered && i == q.correctIndex;
                        final isWrong = _answered && i == _selectedAnswer && i != q.correctIndex;

                        return GestureDetector(
                          onTap: () => _selectAnswer(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _optionColor(i),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: _optionBorder(i), width: 1.5),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 30, height: 30,
                                  decoration: BoxDecoration(
                                    color: isCorrect
                                        ? const Color(0xFF43A047).withOpacity(0.1)
                                        : isWrong
                                        ? const Color(0xFFE53935).withOpacity(0.1)
                                        : const Color(0xFF3949AB).withOpacity(0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: isCorrect
                                        ? const Icon(Icons.check_rounded,
                                        color: Color(0xFF43A047), size: 16)
                                        : isWrong
                                        ? const Icon(Icons.close_rounded,
                                        color: Color(0xFFE53935), size: 16)
                                        : Text(
                                      String.fromCharCode(65 + i),
                                      style: const TextStyle(
                                          color: Color(0xFF3949AB),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(q.options[i],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: isCorrect
                                              ? const Color(0xFF2E7D32)
                                              : isWrong
                                              ? const Color(0xFFC62828)
                                              : const Color(0xFF37474F),
                                          fontWeight: _answered && i == q.correctIndex
                                              ? FontWeight.w600
                                              : FontWeight.normal)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Next button
              if (_answered)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3949AB),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: _next,
                    child: Text(
                      _currentIndex < _questions.length - 1
                          ? 'Next Question →'
                          : 'View My Results →',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}