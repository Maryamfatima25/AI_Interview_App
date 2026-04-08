// lib/data/dummy_jobs.dart

// Predefined dummy jobs (for initial UI demo)
final List<Map<String, dynamic>> dummyJobs = [
  {
    "title": "Frontend Developer",
    "skills": ["React", "JavaScript", "CSS"],
    "experience": "1-2 years",
    "description": "Build and maintain web applications",
    "positions": 2,
  },
  {
    "title": "Backend Developer",
    "skills": ["Python", "Django", "REST APIs"],
    "experience": "2-3 years",
    "description": "Develop backend APIs and manage database",
    "positions": 1,
  },
  {
    "title": "Mobile Developer",
    "skills": ["Flutter", "Dart"],
    "experience": "1-2 years",
    "description": "Create cross-platform mobile applications",
    "positions": 1,
  },
  {
    "title": "ML Engineer",
    "skills": ["Python", "Pandas", "MatplotLib"],
    "experience": "2-3 years",
    "description": "Develop backend APIs and manage database",
    "positions": 8,
  },
  {
    "title": "  UI/UX Designer",
    "skills": ["Figma", "Photoshop", "adobe"],
    "experience": "2-3 years",
    "description": "Make posters",
    "positions": 6,
  }
];

// ✅ Main job list (used in app)
List<Map<String, dynamic>> jobsList = [
  ...dummyJobs
];