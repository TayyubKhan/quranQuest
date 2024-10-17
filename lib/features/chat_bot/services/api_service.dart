// lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<String> quranQuest(String query) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/process_input/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': query}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['response'];
      } else {
        throw Exception('Failed to load data: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

