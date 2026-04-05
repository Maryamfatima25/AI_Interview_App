import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  Color _rankColor(int index) {
    if (index == 0) return const Color(0xFFEF6C00);
    if (index == 1) return const Color(0xFF546E7A);
    if (index == 2) return const Color(0xFF6D4C41);
    return const Color(0xFF3949AB);
  }

  IconData _rankIcon(int index) {
    if (index == 0) return Icons.emoji_events_rounded;
    if (index == 1) return Icons.military_tech_rounded;
    if (index == 2) return Icons.workspace_premium_rounded;
    return Icons.person_outline;
  }

  Color _scoreColor(double score) {
    if (score >= 8) return const Color(0xFF2E7D32);
    if (score >= 6) return const Color(0xFF1565C0);
    if (score >= 4) return const Color(0xFFE65100);
    return const Color(0xFFC62828);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> candidates = [
      {'name': 'Ali', 'resumeScore': 85, 'interviewScore': 8.5},
      {'name': 'Sara', 'resumeScore': 80, 'interviewScore': 7.9},
      {'name': 'Ahmed', 'resumeScore': 40, 'interviewScore': 6.2},
    ];

    for (final c in candidates) {
      c['finalScore'] =
          (c['resumeScore'] as num) * 0.4 / 10 +
              (c['interviewScore'] as num) * 0.6;
    }

    candidates.sort((a, b) =>
        (b['finalScore'] as double)
            .compareTo(a['finalScore'] as double));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Final Results',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E))),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF3949AB)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: candidates.length,
        itemBuilder: (context, index) {
          final candidate = candidates[index];
          final finalScore =
          (candidate['finalScore'] as double);
          final resumeScore =
          (candidate['resumeScore'] as num).toDouble();
          final interviewScore =
          (candidate['interviewScore'] as num).toDouble();
          final rankColor = _rankColor(index);
          final scoreColor = _scoreColor(finalScore);
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
              border: index == 0
                  ? Border.all(
                  color: const Color(0xFFEF6C00).withOpacity(0.4),
                  width: 1.5)
                  : null,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10)
              ],
            ),
            child: Column(
              children: [
                // Colored header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: rankColor,
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
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(candidate['name'] as String,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                            Text('Rank #${index + 1}',
                                style: TextStyle(
                                    color:
                                    Colors.white.withOpacity(0.8),
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_rankIcon(index),
                            color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),

                // Body
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Final score
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Final Score',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF546E7A))),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: scoreColor.withOpacity(0.1),
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                                finalScore.toStringAsFixed(1),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: scoreColor)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1),
                      const SizedBox(height: 14),

                      // Resume match bar
                      _scoreRow('Resume Match', resumeScore, 100,
                          const Color(0xFF00897B)),
                      const SizedBox(height: 12),

                      // Interview score bar
                      _scoreRow('Interview Score', interviewScore,
                          10, const Color(0xFF3949AB)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _scoreRow(
      String label, double value, double max, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF9E9E9E))),
            Text(
                '${value.toStringAsFixed(1)} / ${max.toStringAsFixed(0)}',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value / max,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}