import 'package:flutter/material.dart';

class ShortlistScreen extends StatefulWidget {
  final List<Map<String, dynamic>> candidates;

  const ShortlistScreen({super.key, required this.candidates});

  @override
  State<ShortlistScreen> createState() => _ShortlistScreenState();
}

class _ShortlistScreenState extends State<ShortlistScreen> {
  final Map<String, bool> selected = {};

  @override
  void initState() {
    super.initState();
    for (var c in widget.candidates) {
      selected[c['name']] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shortlist Candidates"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: widget.candidates.map((c) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: CheckboxListTile(
                      value: selected[c['name']],
                      onChanged: (val) {
                        setState(() {
                          selected[c['name']] = val!;
                        });
                      },
                      title: Text(c['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Skills: ${c['skills'].join(', ')}"),
                    ),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                List<Map<String, dynamic>> shortlisted = widget.candidates
                    .where((c) => selected[c['name']] == true)
                    .toList();
                Navigator.pop(context, shortlisted); // send to Interview page
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text("Shortlist Selected"),
            )
          ],
        ),
      ),
    );
  }
}