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
  final TextEditingController answerController = TextEditingController();
  final TextEditingController scoreController = TextEditingController();

  final List<String> questions = [
    'Explain your most recent project and your role in it.',
    'What is your greatest strength as a developer?',
    'Why do you want to join this company?',
  ];

  void _next() {
    final scoreTxt = scoreController.text.trim();
    final score = double.tryParse(scoreTxt);
    if (score == null || score < 1 || score > 10) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please enter a valid score between 1 and 10'),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      return;
    }

    final candidateName =
    widget.shortlistedCandidates[current]['name'] as String;
    interviewScores[candidateName] = score;

    if (current + 1 < widget.shortlistedCandidates.length) {
      setState(() {
        current++;
        answerController.clear();
        scoreController.clear();
      });
    } else {
      Navigator.pop(context, interviewScores);
    }
  }

  bool get isLast => current + 1 >= widget.shortlistedCandidates.length;

  @override
  Widget build(BuildContext context) {

    if (widget.shortlistedCandidates.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Interview')),
        body: Center(
          child: Text('No candidates yet'),
        ),
      );
    }

    final candidate = widget.shortlistedCandidates[current];
    final question = questions[current % questions.length];
    final progress = (current + 1) / widget.shortlistedCandidates.length;
    final initials = (candidate['name'] as String)
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();

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
                    child: const Icon(Icons.record_voice_over_rounded,
                        color: Color(0xFF3949AB), size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Live Interview',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E))),
                      Text('Recruiter evaluation',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF7986CB))),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '${current + 1}/${widget.shortlistedCandidates.length}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3949AB)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white,
                  valueColor:
                  const AlwaysStoppedAnimation(Color(0xFF3949AB)),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 6),

              // Candidate dots
              Row(
                children: List.generate(
                    widget.shortlistedCandidates.length,
                        (i) => Expanded(
                      child: Container(
                        margin:
                        const EdgeInsets.symmetric(horizontal: 2),
                        height: 4,
                        decoration: BoxDecoration(
                          color: i < current
                              ? const Color(0xFF43A047)
                              : i == current
                              ? const Color(0xFF3949AB)
                              .withOpacity(0.4)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 24),

              // Candidate card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8)
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color:
                        const Color(0xFF3949AB).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(initials,
                            style: const TextStyle(
                                color: Color(0xFF3949AB),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(candidate['name'] as String,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A237E))),
                        Text(
                            candidate['jobTitle'] != null
                                ? 'Applying for ${candidate['jobTitle']}'
                                : 'Candidate',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF7986CB))),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                        const Color(0xFF3949AB).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                          'Interview ${current + 1}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF3949AB),
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Question card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF3949AB),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color:
                        const Color(0xFF3949AB).withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                          'Question ${(current % questions.length) + 1}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ),
                    const SizedBox(height: 12),
                    Text(question,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Answer field
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Candidate\'s Answer'),
                      const SizedBox(height: 8),
                      _textArea(answerController,
                          'Type the candidate\'s answer here...', 4),
                      const SizedBox(height: 16),

                      _label('Score (1 – 10)'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _inputField(
                              scoreController,
                              'Enter score',
                              Icons.star_outline_rounded,
                              isNumber: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Score quick-pick
                          ...['5', '7', '9'].map((v) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: GestureDetector(
                              onTap: () => setState(
                                      () => scoreController.text = v),
                              child: Container(
                                width: 40,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: scoreController.text == v
                                      ? const Color(0xFF3949AB)
                                      : Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.05),
                                        blurRadius: 6)
                                  ],
                                ),
                                child: Center(
                                  child: Text(v,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color:
                                          scoreController.text ==
                                              v
                                              ? Colors.white
                                              : const Color(
                                              0xFF3949AB))),
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Next / Finish button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLast
                        ? const Color(0xFF43A047)
                        : const Color(0xFF3949AB),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  onPressed: _next,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          isLast
                              ? Icons.check_circle_outline_rounded
                              : Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20),
                      const SizedBox(width: 8),
                      Text(
                          isLast
                              ? 'Finish Interviews'
                              : 'Next Candidate',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t,
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF546E7A)));

  Widget _textArea(
      TextEditingController c, String hint, int maxLines) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A237E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              color: Color(0xFFB0BEC5), fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _inputField(
      TextEditingController c, String hint, IconData icon,
      {bool isNumber = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: TextField(
        controller: c,
        keyboardType:
        isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A237E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              color: Color(0xFFB0BEC5), fontSize: 13),
          prefixIcon:
          Icon(icon, color: const Color(0xFF7986CB), size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}