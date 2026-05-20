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
    final jsonList = postedJobs.map((j) => {
      'title':       j['title']       ?? '',
      'skills':      j['skills']      ?? [],
      'experience':  j['experience']  ?? '',
      'description': j['description'] ?? '',
      'positions':   j['positions']   ?? '1',
      'salary':      j['salary']      ?? '',
      'postedAt':    j['postedAt']    ?? '',
      'isNew':       j['isNew']       ?? true,
    }).toList();
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
    postedJobs = jsonList.map((j) => {
      'title':       j['title']       ?? '',
      'skills':      List<String>.from(j['skills'] ?? []),
      'experience':  j['experience']  ?? '',
      'description': j['description'] ?? '',
      'positions':   j['positions']   ?? '1',
      'salary':      j['salary']      ?? '',
      'postedAt':    j['postedAt']    ?? '',
      'isNew':       j['isNew']       ?? true,
    }).toList();
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