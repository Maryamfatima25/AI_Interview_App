// lib/models/applicant_model.dart

class ApplicantModel {
  String name;
  String email;
  String password;
  List<String> skills;
  String experience;
  String appliedJobTitle;       // most recent job
  double resumeMatchScore;
  double interviewScore;
  String aiVerdict;

  // ✅ NEW — tracks all jobs this applicant applied to
  List<Map<String, dynamic>> appliedJobs;

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
    this.appliedJobs      = const [],
  });
}

ApplicantModel currentApplicant = ApplicantModel();