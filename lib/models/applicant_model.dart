// lib/models/applicant_model.dart

class ApplicantModel {
  String name;
  String email;
  String password;
  List<String> skills;
  String experience;
  String appliedJobTitle;
  double resumeMatchScore;
  double interviewScore;
  String aiVerdict;

  ApplicantModel({
    this.name             = '',
    this.email            = '',
    this.password         = '',
    this.skills           = const [],
    this.experience       = '',
    this.appliedJobTitle  = '',
    this.resumeMatchScore = 0.0,
    this.interviewScore   = 0.0,
    this.aiVerdict        = '',
  });
}

// Global session object for the currently logged-in applicant
ApplicantModel currentApplicant = ApplicantModel();