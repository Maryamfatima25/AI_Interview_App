import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../data/dummy_jobs.dart';
import 'job_detail_screen.dart';

// ─── App-wide 2-Color Palette ─────────────────────────────────────────────────
class AppColors {
  // PRIMARY — Navy
  static const navy         = Color(0xFF1B3165);
  static const navyLight    = Color(0xFF284B9F);

  // ACCENT — Teal
  static const teal         = Color(0xFF00B4A6);
  static const tealLight    = Color(0xFFE0F7F6);
  static const tealDark     = Color(0xFF007A70);

  // Neutrals
  static const surface      = Color(0xFFF4F6FB);
  static const card         = Colors.white;
  static const border       = Color(0xFFE8ECF4);
  static const textPrimary  = Color(0xFF0D1B3E);
  static const textSub      = Color(0xFF5A6A8A);
  static const textHint     = Color(0xFFABB8D4);
}
// ─────────────────────────────────────────────────────────────────────────────

class JobListingsScreen extends StatefulWidget {
  const JobListingsScreen({super.key});

  @override
  State<JobListingsScreen> createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends State<JobListingsScreen> {
  String _search = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobs = dummyJobs.where((j) {
      final title = (j['title'] as String).toLowerCase();
      return title.contains(_search.toLowerCase());
    }).toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: Column(
          children: [
            _buildHeader(jobs.length),
            Expanded(
              child: jobs.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                itemCount: jobs.length,
                itemBuilder: (ctx, i) => _buildJobCard(ctx, jobs[i], i),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(int count) {
    return Container(
      color: AppColors.navy,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top title row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Teal accent bar
                  Container(
                    width: 4,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.teal,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Job Openings',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.3)),
                        Text('Discover your next opportunity',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white54)),
                      ],
                    ),
                  ),
                  // Count badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.teal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('$count Jobs',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ── Search bar sitting at bottom of header ─────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                color: AppColors.navyLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.teal.withOpacity(0.35), width: 1.2),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _search = v),
                style: const TextStyle(
                    fontSize: 14, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search job title...',
                  hintStyle: const TextStyle(
                      color: Colors.white38, fontSize: 13),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppColors.teal, size: 20),
                  suffixIcon: _search.isNotEmpty
                      ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _search = '');
                    },
                    child: const Icon(Icons.close_rounded,
                        color: Colors.white38, size: 18),
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Teal divider line at bottom of header ──────────────────────
            Container(height: 3, color: AppColors.teal),
          ],
        ),
      ),
    );
  }

  // ── Job card ────────────────────────────────────────────────────────────────
  Widget _buildJobCard(BuildContext ctx, Map<String, dynamic> job, int i) {
    final skills = (job['skills'] as List).cast<String>();
    // Alternate: navy header vs teal header
    final isNavy = i.isEven;
    final headerColor = isNavy ? AppColors.navy : AppColors.tealDark;
    final chipColor   = isNavy ? AppColors.navy : AppColors.tealDark;

    return GestureDetector(
      onTap: () => Navigator.push(ctx,
          MaterialPageRoute(builder: (_) => JobDetailScreen(job: job))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
                color: AppColors.navy.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            // ── Colored header strip ────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(Icons.business_center_outlined,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job['title'] as String,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('${job['positions']} position(s) open',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.65),
                                fontSize: 11)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.teal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Apply',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // ── Card body ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule_outlined,
                          color: AppColors.textSub, size: 14),
                      const SizedBox(width: 5),
                      Text(job['experience'] as String,
                          style: const TextStyle(
                              color: AppColors.textSub,
                              fontSize: 12)),
                      const SizedBox(width: 16),
                      if (job['salary'] != null) ...[
                        const Icon(Icons.payments_outlined,
                            color: AppColors.tealDark, size: 14),
                        const SizedBox(width: 5),
                        Text(job['salary'] as String,
                            style: const TextStyle(
                                color: AppColors.tealDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 7,
                    runSpacing: 6,
                    children: skills
                        .map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: chipColor.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: chipColor.withOpacity(0.2)),
                      ),
                      child: Text(s,
                          style: TextStyle(
                              color: chipColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty state ─────────────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.tealLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off_rounded,
                color: AppColors.tealDark, size: 40),
          ),
          const SizedBox(height: 16),
          const Text('No jobs found',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Try searching with a different keyword',
              style: TextStyle(
                  color: AppColors.textSub, fontSize: 13)),
        ],
      ),
    );
  }
}