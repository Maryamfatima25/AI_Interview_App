import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/generated_profile.dart';
import '../data/skill_keywords.dart';

class CVParserService {
  static Future<GeneratedProfile?> pickAndParse() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String text = await _extractTextFromPdf(file);
        return _parseProfileFromText(text, result.files.single.name);
      }
    } catch (e) {
      // CV Parsing Error
    }
    return null;
  }

  static Future<String> _extractTextFromPdf(File file) async {
    final PdfDocument document = PdfDocument(inputBytes: file.readAsBytesSync());
    String text = PdfTextExtractor(document).extractText();
    document.dispose();
    return text;
  }

  static GeneratedProfile _parseProfileFromText(String text, String fileName) {
    final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    final lowerText = text.toLowerCase();
    
    // 1. Improved Name Detection: 
    // Usually, the name is in the first 2-3 lines of a CV
    String extractedName = fileName.split('.').first; // Default
    if (lines.isNotEmpty) {
      // Pick the first line as a potential name if it's not too long and doesn't look like an email
      final firstLine = lines[0];
      if (firstLine.length > 3 && firstLine.length < 30 && !firstLine.contains('@')) {
        extractedName = firstLine;
      }
    }

    // 2. Simple skill detection based on keywords
    List<String> detectedSkills = [];
    for (var skill in allKnownSkills) {
      if (lowerText.contains(skill.toLowerCase())) {
        detectedSkills.add(skill);
      }
    }

    // 3. Attempt to find experience level
    String experience = '0-1 years';
    if (lowerText.contains('5+ years') || lowerText.contains('senior')) {
      experience = '5+ years';
    } else if (lowerText.contains('3 years') || lowerText.contains('4 years')) {
      experience = '3-5 years';
    }

    return GeneratedProfile(
      fullName: extractedName,
      email: _extractEmail(text) ?? '',
      skills: detectedSkills.toSet().toList(),
      about: 'Extracted from CV',
      experience: [experience],
    );
  }

  static String? _extractEmail(String text) {
    final emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    return emailRegex.firstMatch(text)?.group(0);
  }
}
