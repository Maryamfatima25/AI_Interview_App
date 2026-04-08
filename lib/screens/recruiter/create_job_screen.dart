import 'package:flutter/material.dart';
import '../../data/job_store.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final TextEditingController titleController      = TextEditingController();
  final TextEditingController skillsController     = TextEditingController();
  final TextEditingController expController        = TextEditingController();
  final TextEditingController descController       = TextEditingController();
  final TextEditingController positionsController  = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    titleController.dispose();
    skillsController.dispose();
    expController.dispose();
    descController.dispose();
    positionsController.dispose();
    super.dispose();
  }

  void _createJob() async {
    // ── Validation ──────────────────────────────────────────
    if (titleController.text.trim().isEmpty) {
      _showSnack('Job title is required', isError: true);
      return;
    }
    if (skillsController.text.trim().isEmpty) {
      _showSnack('Required skills cannot be empty', isError: true);
      return;
    }
    if (positionsController.text.trim().isEmpty) {
      _showSnack('Number of positions is required', isError: true);
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _loading = false);

    // ── Parse skills ─────────────────────────────────────────
    final skillsList = skillsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // ── Build job map ─────────────────────────────────────────
    final job = {
      'title':       titleController.text.trim(),
      'skills':      skillsList,
      'experience':  expController.text.trim().isEmpty
          ? 'Not specified'
          : expController.text.trim(),
      'description': descController.text.trim().isEmpty
          ? 'No description provided'
          : descController.text.trim(),
      'positions':   positionsController.text.trim(),
      'postedAt':    DateTime.now().toString(), // timestamp for applicant side
      'isNew':       true,                      // flag so applicant sees NEW badge
    };

    // ── Write to shared store ─────────────────────────────────
    // ✅ FIX: was jobsList.add(job) — changed to postedJobs.add(job)
    // postedJobs is read by allJobsForApplicant getter on applicant side
    postedJobs.add(job);
    await saveJobsToFile();

    _showSnack('Job created successfully!');
    await Future.delayed(const Duration(milliseconds: 600));

    // ── Return job to dashboard ───────────────────────────────
    if (mounted) Navigator.pop(context, job);
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor:
      isError ? const Color(0xFFE53935) : const Color(0xFF43A047),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Create Job',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E))),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF3949AB)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header banner ────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF3949AB),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF3949AB).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6))
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add_business_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('New Job Posting',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      Text('Fill in the details below',
                          style: TextStyle(
                              color: Color(0xFFB3BCF5),
                              fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Basic Info ───────────────────────────────────
            _sectionTitle('Basic Information'),
            const SizedBox(height: 14),

            _label('Job Title *'),
            const SizedBox(height: 8),
            _field(titleController, 'e.g. Flutter Developer',
                Icons.work_outline),
            const SizedBox(height: 16),

            _label('Number of Positions *'),
            const SizedBox(height: 8),
            _field(positionsController, 'e.g. 3',
                Icons.people_outline, isNumber: true),
            const SizedBox(height: 16),

            _label('Experience Required'),
            const SizedBox(height: 8),
            _field(expController, 'e.g. 2-3 years',
                Icons.schedule_rounded),
            const SizedBox(height: 28),

            // ── Job Details ──────────────────────────────────
            _sectionTitle('Job Details'),
            const SizedBox(height: 14),

            _label('Required Skills *'),
            const SizedBox(height: 8),
            _field(skillsController,
                'e.g. Flutter, Dart, Firebase',
                Icons.psychology_outlined),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(
                'Separate skills with commas',
                style: TextStyle(
                    fontSize: 11, color: Color(0xFF9E9E9E)),
              ),
            ),
            const SizedBox(height: 16),

            _label('Job Description'),
            const SizedBox(height: 8),
            _field(
              descController,
              'Describe the role, responsibilities and requirements...',
              Icons.description_outlined,
              maxLines: 4,
            ),
            const SizedBox(height: 28),

            // ── Preview chips — live skill preview ───────────
            // Shows skills as chips as recruiter types them
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: skillsController,
              builder: (_, value, __) {
                final chips = value.text
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();

                if (chips.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Skills preview:',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7986CB))),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: chips
                          .map((s) => Container(
                        padding:
                        const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3949AB)
                              .withOpacity(0.1),
                          borderRadius:
                          BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(
                                  0xFF3949AB)
                                  .withOpacity(0.3)),
                        ),
                        child: Text(s,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF3949AB),
                                fontWeight:
                                FontWeight.w500)),
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),

            // ── Create button ────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3949AB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: _loading ? null : _createJob,
                child: _loading
                    ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                    : const Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded,
                        color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Create Job Posting',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A237E)));

  Widget _label(String t) => Text(t,
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF546E7A)));

  Widget _field(
      TextEditingController controller,
      String hint,
      IconData icon, {
        int maxLines = 1,
        bool isNumber = false,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF3949AB).withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType:
        isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(
            fontSize: 14, color: Color(0xFF1A237E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              color: Color(0xFFB0BEC5), fontSize: 13),
          prefixIcon: Padding(
            padding:
            EdgeInsets.only(bottom: maxLines > 1 ? 50 : 0),
            child: Icon(icon,
                color: const Color(0xFF7986CB), size: 18),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}