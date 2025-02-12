import 'dart:convert';
import 'package:http/http.dart' as http;

class TextCorrectionService {
  final String apiUrl = 'https://api.languagetool.org/v2/check'; // LanguageTool API URL

  Future<String> correctText(String text, {String language = 'en'}) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'text': text,
        'language': language,  // Use dynamic language selection (English: 'en', Arabic: 'ar')
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      // Log the API response to check what is being returned
      print('API Response: $data');
      
      // If there are matches (errors), apply corrections
      if (data['matches'].isNotEmpty) {
        String correctedText = text;

        // Sort matches by offset to ensure proper sequence
        List matches = data['matches'];
        matches.sort((a, b) => a['offset'] - b['offset']); // Sort by offset to avoid replacement conflicts

        // Start from the last match to avoid offset issues when modifying text
        int offsetAdjustment = 0;

        // Apply all corrections in the correct order
        for (var match in matches) {
          // Log the rule ID and correction to debug
          print('Match: ${match['message']}, Rule ID: ${match['rule']['id']}');

          // Get the first replacement suggestion (you could use the best suggestion)
          String replacement = match['replacements'][0]['value'];

          int offset = match['offset'] + offsetAdjustment;  // Adjust offset after each replacement
          int length = match['length'];

          // Apply the correction (grammar or spelling)
          correctedText = correctedText.replaceRange(offset, offset + length, replacement);

          // Adjust offset for subsequent replacements
          offsetAdjustment += (replacement.length - length);
        }

        return correctedText;
      } else {
        return text;  // No corrections needed
      }
    } else {
      throw Exception('Failed to load corrections');
    }
  }
}
