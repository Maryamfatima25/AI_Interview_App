import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/applicant_model.dart';
import '../models/generated_profile.dart';

/// Persists applicant CV / profile per Firebase user so data survives logout.
class ApplicantProfileCache {
  ApplicantProfileCache._();

  static String _key(String uid) => 'applicant_profile_v1_$uid';

  static Map<String, dynamic>? _profileToJson(GeneratedProfile g) => {
        'fullName': g.fullName,
        'email': g.email,
        'skills': g.skills,
        'about': g.about,
        'experience': g.experience,
      };

  static GeneratedProfile? _profileFromJson(Object? raw) {
    if (raw is! Map) return null;
    final m = Map<String, dynamic>.from(raw);
    return GeneratedProfile(
      fullName: m['fullName'] as String? ?? '',
      email: m['email'] as String? ?? '',
      skills: List<String>.from(m['skills'] as List? ?? const []),
      about: m['about'] as String? ?? '',
      experience: List<dynamic>.from(m['experience'] as List? ?? const []),
    );
  }

  /// Writes [currentApplicant] and optional last CV parse snapshot for [uid].
  static Future<void> save(
    String uid,
    ApplicantModel a, {
    GeneratedProfile? cvSnapshot,
  }) async {
    if (uid.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic>? existing;
    final old = prefs.getString(_key(uid));
    if (old != null && old.isNotEmpty) {
      try {
        existing = Map<String, dynamic>.from(jsonDecode(old) as Map);
      } catch (_) {}
    }

    Map<String, dynamic>? gpJson;
    if (cvSnapshot != null) {
      gpJson = _profileToJson(cvSnapshot);
    } else if (existing != null && existing['generatedProfile'] != null) {
      gpJson = Map<String, dynamic>.from(
        existing['generatedProfile'] as Map,
      );
    }

    final map = <String, dynamic>{
      'name': a.name,
      'email': a.email,
      'skills': a.skills,
      'experience': a.experience,
      'appliedJobTitle': a.appliedJobTitle,
      'resumeMatchScore': a.resumeMatchScore,
      'interviewScore': a.interviewScore,
      'aiVerdict': a.aiVerdict,
    };
    if (gpJson != null) {
      map['generatedProfile'] = gpJson;
    }
    await prefs.setString(_key(uid), jsonEncode(map));
  }

  /// Restores [currentApplicant]. Returns CV snapshot for UI if present.
  static Future<GeneratedProfile?> loadIntoCurrentApplicant(String uid) async {
    if (uid.isEmpty) return null;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(uid));
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      currentApplicant.name = map['name'] as String? ?? '';
      currentApplicant.email = map['email'] as String? ?? '';
      currentApplicant.skills =
          List<String>.from(map['skills'] as List? ?? const []);
      currentApplicant.experience = map['experience'] as String? ?? '';
      currentApplicant.appliedJobTitle =
          map['appliedJobTitle'] as String? ?? '';
      currentApplicant.resumeMatchScore =
          (map['resumeMatchScore'] as num?)?.toDouble() ?? 0.0;
      currentApplicant.interviewScore =
          (map['interviewScore'] as num?)?.toDouble() ?? 0.0;
      currentApplicant.aiVerdict = map['aiVerdict'] as String? ?? '';
      return _profileFromJson(map['generatedProfile']);
    } catch (_) {
      return null;
    }
  }

  /// Last saved CV parse UI snapshot (does not mutate [currentApplicant]).
  static Future<GeneratedProfile?> loadGeneratedProfileSnapshot(
      String uid) async {
    if (uid.isEmpty) return null;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(uid));
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      return _profileFromJson(map['generatedProfile']);
    } catch (_) {
      return null;
    }
  }
}
