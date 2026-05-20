// lib/utils/data_helper.dart
// Single place that merges Firebase + dummy data
// Import this instead of importing dummy files directly

import '../data/dummy_jobs.dart';
import '../data/dummy_candidates.dart';

// ── Merge Firebase jobs with dummy jobs ──────────────────
// firebaseJobs come from StreamBuilder snapshot
// Returns merged list — Firebase first, dummy fills the rest
List<Map<String, dynamic>> mergeJobs(
    List<Map<String, dynamic>> firebaseJobs) {
  // Tag dummy jobs so UI can distinguish them
  final taggedDummy = dummyJobs
      .map((j) => {...j, 'isDemo': true})
      .toList();

  // Avoid duplicates by title
  final firebaseTitles = firebaseJobs
      .map((j) => (j['title'] as String).toLowerCase())
      .toSet();

  final filteredDummy = taggedDummy
      .where((j) => !firebaseTitles
      .contains((j['title'] as String).toLowerCase()))
      .toList();

  return [...firebaseJobs, ...filteredDummy];
}

// ── Merge Firebase applicants with dummy candidates ──────
List<Map<String, dynamic>> mergeApplicants(
    List<Map<String, dynamic>> firebaseApps) {
  // Convert dummy candidates to application format
  final dummyAsApps = dummyCandidates.map((c) => {
    'applicantName':   c['name'],
    'applicantEmail':  '${(c['name'] as String).toLowerCase()}@demo.com',
    'applicantUid':    'demo_${c['name']}',
    'jobTitle':        c['jobTitle'],
    'jobId':           'demo',
    'skills':          c['skills'],
    'experience':      '1-2 years',
    'matchScore':      c['resumeScore'],
    'interviewScore':  c['interviewScore'],
    'aiVerdict':       _verdictFromScore(
        (c['interviewScore'] as num).toDouble()),
    'status':          'Interview Completed',
    'isDemo':          true,
  }).toList();

  // Real applicants always first
  return [...firebaseApps, ...dummyAsApps];
}

String _verdictFromScore(double score) {
  if (score >= 8) return 'Excellent performance!';
  if (score >= 6) return 'Good performance.';
  if (score >= 4) return 'Average performance.';
  return 'Below expectations.';
}