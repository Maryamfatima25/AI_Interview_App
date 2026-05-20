import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class JobService {
  static final _db = FirebaseFirestore.instance;

  // ── Create job — recruiter only ──────────────────────────
  static Future<String?> createJob({
    required String title,
    required List<String> skills,
    required String experience,
    required String description,
    required String positions,
  }) async {
    try {
      await _db.collection('jobs').add({
        'title':       title,
        'skills':      skills,
        'experience':  experience,
        'description': description,
        'positions':   positions,
        'postedBy':    AuthService.currentUid,
        'postedByName':AuthService.currentName,
        'postedAt':    FieldValue.serverTimestamp(),
        'isActive':    true,
      });
      return null; // success
    } catch (e) {
      return 'Failed to post job: $e';
    }
  }

  // ── All active jobs — applicant listings ─────────────────
  // StreamBuilder listens to this — UI updates in real time
  static Stream<List<Map<String, dynamic>>> getJobsStream() {
    return _db
        .collection('jobs')
        .where('isActive', isEqualTo: true)
        .orderBy('postedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => {
      'id': doc.id,
      ...doc.data(),
    })
        .toList());
  }

  // ── Jobs by this recruiter only ──────────────────────────
  static Stream<List<Map<String, dynamic>>>
  getMyJobsStream() {
    return _db
        .collection('jobs')
        .where('postedBy',
        isEqualTo: AuthService.currentUid)
        .orderBy('postedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => {
      'id': doc.id,
      ...doc.data(),
    })
        .toList());
  }

  // ── Get single job by id ─────────────────────────────────
  static Future<Map<String, dynamic>?> getJobById(
      String jobId) async {
    try {
      final doc =
      await _db.collection('jobs').doc(jobId).get();
      if (!doc.exists) return null;
      return {'id': doc.id, ...doc.data()!};
    } catch (_) {
      return null;
    }
  }
}