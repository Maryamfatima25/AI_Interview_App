import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// UserRole lives here to avoid circular imports
enum UserRole { recruiter, applicant }

class AuthService {
  static Future<UserRole?> login(String email, String password) async {
    try {
      final recruitersJson =
      await rootBundle.loadString('../../assets/recruiters.json');
      final applicantsJson =
      await rootBundle.loadString('../../assets/applicants.json');

      final recruiters = jsonDecode(recruitersJson) as List<dynamic>;
      final applicants = jsonDecode(applicantsJson) as List<dynamic>;

      for (var rec in recruiters) {
        if (rec['id'] == email && rec['password'] == password) {
          return UserRole.recruiter;
        }
      }

      for (var app in applicants) {
        if (app['id'] == email && app['password'] == password) {
          return UserRole.applicant;
        }
      }
    } catch (e) {
      // Surface the error so it's visible during development
      print('AuthService.login error: $e');
    }

    return null;
  }

  static Future<void> registerApplicant(String email, String password) async {
    // Demo only — does not persist to JSON
    print('New applicant registered: $email / $password');
  }
}