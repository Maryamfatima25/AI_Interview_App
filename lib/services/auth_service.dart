import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/applicant_model.dart';

// UserRole lives here to avoid circular imports
enum UserRole { recruiter, applicant }

class AuthService {
  // In-memory list for demo registrations
  static final List<Map<String, String>> _registeredApplicants = [];

  static Future<UserRole?> login(String email, String password) async {
    try {
      // 1. Check recruiters
      try {
        final recruitersJson = await rootBundle.loadString('assets/recruiters.json');
        final recruiters = jsonDecode(recruitersJson) as List<dynamic>;
        for (var rec in recruiters) {
          if (rec['id'] == email && rec['password'] == password) {
            return UserRole.recruiter;
          }
        }
      } catch (e) {
        // Ignored for demo
      }

      // Fallback for admin
      if (email == 'admin' && password == 'admin') return UserRole.recruiter;

      // 2. Check in-memory registered applicants
      for (var app in _registeredApplicants) {
        if (app['email'] == email && app['password'] == password) {
          currentApplicant = ApplicantModel(email: email);
          return UserRole.applicant;
        }
      }

      // 3. Check applicants from assets
      try {
        final applicantsJson = await rootBundle.loadString('assets/applicants.json');
        final applicants = jsonDecode(applicantsJson) as List<dynamic>;
        for (var app in applicants) {
          if (app['id'] == email && app['password'] == password) {
            currentApplicant = ApplicantModel(
              email: email,
              name: app['name'] ?? '',
            );
            return UserRole.applicant;
          }
        }
      } catch (e) {
        // Ignored for demo
      }

    } catch (e) {
      // General error
    }

    return null;
  }

  static Future<void> registerApplicant(String email, String password) async {
    // Demo only — store in memory so login works during this session
    _registeredApplicants.add({
      'email': email,
      'password': password,
    });
  }
}
