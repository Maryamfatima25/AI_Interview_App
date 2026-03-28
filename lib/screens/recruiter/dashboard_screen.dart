import 'package:flutter/material.dart';
import 'create_job_screen.dart';
import 'result_screen.dart';
import 'applicant_screen.dart';
import 'interview_screen.dart';
import 'result_screen.dart';
import 'result_screen_with_scores.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  // ✅ Store created job
  Map<String, dynamic>? createdJob;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recruiter Dashboard"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        // ✅ FIX: Column added
        child: Column(
          children: [

            // Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [

                  // Create Job
                  dashboardCard(
                    context,
                    title: "Create Job",
                    icon: Icons.add_box,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateJobScreen(),
                        ),
                      ).then((jobData) {

                        // ✅ Receive data
                        if (jobData != null) {
                          setState(() {
                            createdJob = jobData;
                          });
                        }
                      });
                    },
                  ),

                  // View Applicants
                  dashboardCard(
                    context,
                    title: "Applicants",
                    icon: Icons.people,
                    color: Colors.green,
                    onTap: () {
                      // Check if a job is created
                      if (createdJob == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please create a job first!")),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplicantsScreen(job: createdJob!),
                        ),
                      ).then((shortlistedCandidates) {
                        if (shortlistedCandidates != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InterviewScreen(
                                shortlistedCandidates: shortlistedCandidates,
                              ),
                            ),
                          ).then((interviewScores) {
                            if (interviewScores != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultScreenWithScores(
                                    job: createdJob!,
                                    interviewScores: interviewScores,
                                  ),
                                ),
                              );
                            }
                          });
                        }
                      });
                    },
                  ),

                  // Shortlisted
                  dashboardCard(
                    context,
                    title: "Shortlisted",
                    icon: Icons.check_circle,
                    color: Colors.orange,
                    onTap: () {
                      // connect later
                    },
                  ),

                  // Interview
                  dashboardCard(
                    context,
                    title: "Interview",
                    icon: Icons.video_call,
                    color: Colors.purple,
                    onTap: () {
                      // connect later
                    },
                  ),

                  // Results
                  dashboardCard(
                    context,
                    title: "Results",
                    icon: Icons.bar_chart,
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResultScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ✅ Show created job
            if (createdJob != null)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Job Created: ${createdJob!['title']}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Reusable Card Widget
  Widget dashboardCard(BuildContext context,
      {required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}