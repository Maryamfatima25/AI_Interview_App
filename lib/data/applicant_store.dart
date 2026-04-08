// lib/data/applicant_store.dart

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/applicant_model.dart';
import 'dummy_candidates.dart';

// ── In-memory list (loaded from file at runtime) ──────────────────────────
List<ApplicantModel> submittedApplicants = [];

// ── File path helper ──────────────────────────────────────────────────────
Future<File> _getStoreFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/submitted_applicants.json');
}

// ── WRITE: call this after submittedApplicants.add(...) ───────────────────
Future<void> saveApplicantsToFile() async {
  try {
    final file = await _getStoreFile();
    final List<Map<String, dynamic>> jsonList = submittedApplicants
        .map((a) => {
      'name':            a.name,
      'email':           a.email,
      'skills':          a.skills,
      'experience':      a.experience,
      'appliedJobTitle': a.appliedJobTitle,
      'interviewScore':  a.interviewScore,
      'aiVerdict':       a.aiVerdict,
    })
        .toList();
    await file.writeAsString(jsonEncode(jsonList));
  } catch (e) {
    // fail silently — app still works with in-memory data
  }
}

// ── READ: call this once at app startup ───────────────────────────────────
Future<void> loadApplicantsFromFile() async {
  try {
    final file = await _getStoreFile();
    if (!await file.exists()) return; // no file yet — first run

    final content = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(content);

    submittedApplicants = jsonList.map((j) => ApplicantModel(
      name:            j['name']            ?? '',
      email:           j['email']           ?? '',
      skills:          List<String>.from(j['skills'] ?? []),
      experience:      j['experience']      ?? '',
      appliedJobTitle: j['appliedJobTitle'] ?? '',
      interviewScore:  (j['interviewScore'] as num?)?.toDouble() ?? 0.0,
      aiVerdict:       j['aiVerdict']       ?? '',
    )).toList();
  } catch (e) {
    submittedApplicants = []; // corrupt file — start fresh
  }
}

// ── Merged list for recruiter (real + dummy) ──────────────────────────────
List<Map<String, dynamic>> get allApplicantsForRecruiter {
  final realAsMap = submittedApplicants.map((a) => {
    'name':           a.name,
    'email':          a.email,
    'jobTitle':       a.appliedJobTitle,
    'skills':         a.skills,
    'experience':     a.experience,
    'interviewScore': a.interviewScore,
    'resumeScore':    0.0,
    'isNew':          true,
  }).toList();

  final dummyTagged = dummyCandidates.map((c) => {
    ...c,
    'isNew': false,
  }).toList();

  return [...realAsMap, ...dummyTagged];
}