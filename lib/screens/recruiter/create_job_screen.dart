import 'package:flutter/material.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController expController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController positionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Job"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Job Title
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Job Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Skills
            TextField(
              controller: skillsController,
              decoration: const InputDecoration(
                labelText: "Required Skills (comma separated)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Experience
            TextField(
              controller: expController,
              decoration: const InputDecoration(
                labelText: "Experience (e.g. 1 year)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Description
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Job Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Positions
            TextField(
              controller: positionsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Number of Positions",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty ||
                    skillsController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fill required fields")),
                  );
                  return;
                }

                // 🔹 Convert skills string → list
                List<String> skillsList = skillsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .toList();

                // 🔹 Create job object (Map for now)
                Map<String, dynamic> job = {
                  "title": titleController.text,
                  "skills": skillsList,
                  "experience": expController.text,
                  "description": descController.text,
                  "positions": positionsController.text,
                };

                // 🔹 Send data back
                Navigator.pop(context, job);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Create Job"),
            ),
          ],
        ),
      ),
    );
  }
}