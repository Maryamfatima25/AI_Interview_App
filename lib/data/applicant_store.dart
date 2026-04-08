import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/applicant_model.dart';
import 'dummy_candidates.dart';

const _kStoreKey = 'submitted_applicants';

// In-memory list
List<ApplicantModel> submittedApplicants = [];

// ── WRITE ────────────────────────────────────────────────────────────────
Future<void> saveApplicantsToFile() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = submittedApplicants.map((a) => {
      'name':            a.name,
      'email':           a.email,
      'skills':          a.skills,
      'experience':      a.experience,
      'appliedJobTitle': a.appliedJobTitle,
      'interviewScore':  a.interviewScore,
      'aiVerdict':       a.aiVerdict,
    }).toList();
    await prefs.setString(_kStoreKey, jsonEncode(jsonList));
    print('✅ Saved to SharedPrefs: ${jsonList.length} applicants');
  } catch (e) {
    print('❌ Save error: $e');
  }
}

// ── READ ─────────────────────────────────────────────────────────────────
Future<void> loadApplicantsFromFile() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kStoreKey);
    if (raw == null || raw.isEmpty) {
      print('🚀 App started — submittedApplicants: 0 (nothing saved yet)');
      submittedApplicants = [];
      return;
    }
    final List<dynamic> jsonList = jsonDecode(raw);
    submittedApplicants = jsonList.map((j) => ApplicantModel(
      name:            j['name']            ?? '',
      email:           j['email']           ?? '',
      skills:          List<String>.from(j['skills'] ?? []),
      experience:      j['experience']      ?? '',
      appliedJobTitle: j['appliedJobTitle'] ?? '',
      interviewScore:  (j['interviewScore'] as num?)?.toDouble() ?? 0.0,
      aiVerdict:       j['aiVerdict']       ?? '',
    )).toList();
    print('🚀 App started — submittedApplicants: ${submittedApplicants.length}');
  } catch (e) {
    print('❌ Load error: $e');
    submittedApplicants = [];
  }
}

// ── Merged list for recruiter ─────────────────────────────────────────────
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