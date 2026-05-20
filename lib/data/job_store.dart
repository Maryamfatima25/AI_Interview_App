// lib/data/job_store.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dummy_jobs.dart';

const _kJobsKey = 'posted_jobs';

// ── In-memory list ────────────────────────────────────────────────────────
List<Map<String, dynamic>> postedJobs = [];

// ── WRITE ─────────────────────────────────────────────────────────────────
Future<void> saveJobsToFile() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = postedJobs
        .map(
          (j) => {
            'title': j['title'] ?? '',
            'skills': j['skills'] ?? [],
            'experience': j['experience'] ?? '',
            'description': j['description'] ?? '',
            'positions': j['positions'] ?? '1',
            'salary': j['salary'] ?? '',
            'postedAt': j['postedAt'] ?? '',
            'isNew': j['isNew'] ?? true,
          },
        )
        .toList();
    await prefs.setString(_kJobsKey, jsonEncode(jsonList));
    if (kDebugMode) {
      debugPrint('✅ Jobs saved: ${jsonList.length}');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('❌ Job save error: $e');
    }
  }
}

// ── READ ──────────────────────────────────────────────────────────────────
Future<void> loadJobsFromFile() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kJobsKey);
    if (raw == null || raw.isEmpty) {
      postedJobs = [];
      if (kDebugMode) {
        debugPrint('🚀 No saved jobs found');
      }
      return;
    }
    final List<dynamic> jsonList = jsonDecode(raw);
    postedJobs = jsonList
        .map(
          (j) => {
            'title': j['title'] ?? '',
            'skills': List<String>.from(j['skills'] ?? []),
            'experience': j['experience'] ?? '',
            'description': j['description'] ?? '',
            'positions': j['positions'] ?? '1',
            'salary': j['salary'] ?? '',
            'postedAt': j['postedAt'] ?? '',
            'isNew': j['isNew'] ?? true,
          },
        )
        .toList();
    if (kDebugMode) {
      debugPrint('🚀 Jobs loaded: ${postedJobs.length}');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('❌ Job load error: $e');
    }
    postedJobs = [];
  }
}

// ── Merged: recruiter-posted jobs FIRST, then dummy jobs ──────────────────
List<Map<String, dynamic>> get allJobsForApplicant {
  return [...postedJobs, ...dummyJobs];
}

/// Dedupe key so the same job is not listed twice (e.g. Firestore + local).
String jobListingDedupeKey(Map<String, dynamic> j) {
  final id = j['id'];
  if (id != null && '$id'.isNotEmpty) {
    return 'id:$id';
  }
  final title = (j['title'] as String? ?? '').toLowerCase().trim();
  final posted = j['postedAt']?.toString() ?? '';
  return 'local:$title|$posted';
}

/// Jobs posted by recruiters on this device + demo jobs, merged with [remote]
/// (e.g. Firestore). Recruiter flow uses [postedJobs]; that data was previously
/// invisible to applicants who only listened to Firestore.
List<Map<String, dynamic>> mergeJobsForApplicantListing(
  List<Map<String, dynamic>> remote,
) {
  final seen = <String>{};
  final out = <Map<String, dynamic>>[];

  void add(Map<String, dynamic> raw) {
    final k = jobListingDedupeKey(raw);
    if (!seen.add(k)) {
      return;
    }
    final copy = Map<String, dynamic>.from(raw);
    final pos = copy['positions'];
    if (pos != null && pos is! String) {
      copy['positions'] = pos.toString();
    }
    out.add(copy);
  }

  for (final j in allJobsForApplicant) {
    add(j);
  }
  for (final j in remote) {
    add(j);
  }
  return out;
}
