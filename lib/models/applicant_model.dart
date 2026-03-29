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
    this.name = '',
    this.email = '',
    this.password = '',
    this.skills = const [],
    this.experience = '',
    this.appliedJobTitle = '',
    this.resumeMatchScore = 0.0,
    this.interviewScore = 0.0,
    this.aiVerdict = '',
  });
}

// A simple global session object — no database needed
ApplicantModel currentApplicant = ApplicantModel();