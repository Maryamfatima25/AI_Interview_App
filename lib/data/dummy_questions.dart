class InterviewQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const InterviewQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

const Map<String, List<InterviewQuestion>> interviewQuestions = {
  "Frontend Developer": [
    InterviewQuestion(
      question: "Which hook is used to manage state in React?",
      options: ["useEffect", "useState", "useContext", "useRef"],
      correctIndex: 1,
    ),
    InterviewQuestion(
      question: "What does CSS stand for?",
      options: ["Computer Style Sheets", "Cascading Style Sheets", "Creative Style Syntax", "Colorful Style Sheets"],
      correctIndex: 1,
    ),
    InterviewQuestion(
      question: "Which method is used to iterate over an array in JavaScript?",
      options: ["map()", "filter()", "forEach()", "All of the above"],
      correctIndex: 3,
    ),
    InterviewQuestion(
      question: "What is the virtual DOM in React?",
      options: [
        "A copy of the real DOM kept in memory",
        "A database for UI components",
        "A CSS rendering engine",
        "A JavaScript compiler"
      ],
      correctIndex: 0,
    ),
    InterviewQuestion(
      question: "Which CSS property controls the text size?",
      options: ["font-weight", "text-size", "font-size", "text-scale"],
      correctIndex: 2,
    ),
  ],
  "Backend Developer": [
    InterviewQuestion(
      question: "What does REST stand for?",
      options: [
        "Rapid Execution State Transfer",
        "Representational State Transfer",
        "Remote Execution Standard Transfer",
        "Resource State Transmission"
      ],
      correctIndex: 1,
    ),
    InterviewQuestion(
      question: "Which Python framework is used for building REST APIs?",
      options: ["Flask only", "Django only", "Django REST Framework", "PyAPI"],
      correctIndex: 2,
    ),
    InterviewQuestion(
      question: "What is a foreign key in a relational database?",
      options: [
        "A key imported from another system",
        "A key that links two tables together",
        "An encrypted primary key",
        "A key used for authentication"
      ],
      correctIndex: 1,
    ),
    InterviewQuestion(
      question: "Which HTTP method is used to update a resource?",
      options: ["GET", "POST", "PUT", "DELETE"],
      correctIndex: 2,
    ),
    InterviewQuestion(
      question: "What does ORM stand for in backend development?",
      options: [
        "Object Relational Mapping",
        "Open Resource Management",
        "Oriented Runtime Module",
        "Output Rendering Model"
      ],
      correctIndex: 0,
    ),
  ],
  "Mobile Developer": [
    InterviewQuestion(
      question: "Which language is used to write Flutter apps?",
      options: ["Kotlin", "Swift", "Dart", "Java"],
      correctIndex: 2,
    ),
    InterviewQuestion(
      question: "What is a Widget in Flutter?",
      options: [
        "A database model",
        "The basic building block of a Flutter UI",
        "A network request handler",
        "A routing mechanism"
      ],
      correctIndex: 1,
    ),
    InterviewQuestion(
      question: "Which widget is used to display a scrollable list?",
      options: ["Column", "Stack", "ListView", "GridView"],
      correctIndex: 2,
    ),
    InterviewQuestion(
      question: "What does StatefulWidget allow in Flutter?",
      options: [
        "Static UI that never changes",
        "UI that can rebuild when data changes",
        "Background service execution",
        "Direct hardware access"
      ],
      correctIndex: 1,
    ),
    InterviewQuestion(
      question: "Which command runs a Flutter app?",
      options: ["flutter start", "flutter run", "flutter build", "flutter launch"],
      correctIndex: 1,
    ),
  ],
  "Full Stack Developer": [
    InterviewQuestion(
      question: "What is Node.js primarily used for?",
      options: [
        "Mobile app development",
        "Server-side JavaScript execution",
        "Database management",
        "UI rendering"
      ],
      correctIndex: 1,
    ),
    InterviewQuestion(
      question: "In MongoDB, data is stored as?",
      options: ["Tables and rows", "JSON-like documents", "XML files", "Binary blobs"],
      correctIndex: 1,
    ),
    InterviewQuestion(
      question: "What is the purpose of Express.js?",
      options: [
        "A CSS framework",
        "A minimal Node.js web framework",
        "A React state manager",
        "A testing library"
      ],
      correctIndex: 1,
    ),
    InterviewQuestion(
      question: "What does CORS stand for?",
      options: [
        "Cross-Origin Resource Sharing",
        "Client Object Request Service",
        "Centralized Open Routing System",
        "Component-Oriented Rendering Service"
      ],
      correctIndex: 0,
    ),
    InterviewQuestion(
      question: "Which React hook replaces componentDidMount?",
      options: ["useState", "useCallback", "useEffect", "useMemo"],
      correctIndex: 2,
    ),
  ],
};

// Fallback questions if job title doesn't match
const List<InterviewQuestion> genericQuestions = [
  InterviewQuestion(
    question: "What does API stand for?",
    options: [
      "Application Programming Interface",
      "Automated Process Integration",
      "Advanced Protocol Interface",
      "Application Process Input"
    ],
    correctIndex: 0,
  ),
  InterviewQuestion(
    question: "What is version control used for?",
    options: [
      "Controlling app permissions",
      "Tracking changes in code over time",
      "Managing server versions",
      "Controlling UI versions"
    ],
    correctIndex: 1,
  ),
  InterviewQuestion(
    question: "Which of these is a version control system?",
    options: ["Docker", "Git", "Linux", "Nginx"],
    correctIndex: 1,
  ),
  InterviewQuestion(
    question: "What does UI stand for?",
    options: ["Unified Integration", "User Interface", "Universal Input", "Unified Index"],
    correctIndex: 1,
  ),
  InterviewQuestion(
    question: "What is Agile methodology?",
    options: [
      "A programming language",
      "A project management approach using iterations",
      "A database design pattern",
      "A type of network protocol"
    ],
    correctIndex: 1,
  ),
];