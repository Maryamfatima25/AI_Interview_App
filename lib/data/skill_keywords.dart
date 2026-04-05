// lib/data/skill_keywords.dart
// Every skill keyword we know about, grouped by job category.
// The CV text is scanned against ALL of these.

const Map<String, List<String>> skillsByCategory = {
  "Frontend Developer": [
    "react", "reactjs", "javascript", "js", "css", "css3", "html", "html5",
    "typescript", "redux", "tailwind", "bootstrap", "sass", "scss",
    "next.js", "nextjs", "vue", "vuejs", "angular", "webpack", "vite",
    "figma", "responsive design", "dom", "jquery",
  ],
  "Backend Developer": [
    "python", "django", "flask", "fastapi", "sql", "postgresql", "mysql",
    "rest api", "restful", "api", "node", "nodejs", "express", "java",
    "spring", "php", "laravel", "mongodb", "redis", "docker", "linux",
    "bash", "orm", "jwt", "authentication",
  ],
  "Mobile Developer": [
    "flutter", "dart", "android", "ios", "kotlin", "swift", "react native",
    "firebase", "xcode", "gradle", "mobile development", "apk",
    "state management", "provider", "bloc", "riverpod", "getx",
  ],
  "Full Stack Developer": [
    "react", "node", "nodejs", "mongodb", "express", "mern", "javascript",
    "html", "css", "rest api", "git", "github", "docker", "aws",
    "full stack", "frontend", "backend", "typescript", "next.js",
  ],
  "Data Analyst": [
    "python", "pandas", "numpy", "excel", "sql", "tableau", "power bi",
    "matplotlib", "seaborn", "data analysis", "data visualization",
    "machine learning", "statistics", "r", "jupyter", "data cleaning",
    "etl", "analytics",
  ],
  "UI/UX Designer": [
    "figma", "adobe xd", "sketch", "invision", "prototyping", "wireframe",
    "user research", "ux", "ui", "design system", "usability testing",
    "user interface", "user experience", "canva", "adobe illustrator",
    "photoshop", "accessibility", "information architecture",
  ],
};

// Flat list of ALL known skills for general detection
List<String> get allKnownSkills =>
    skillsByCategory.values.expand((s) => s).toSet().toList();