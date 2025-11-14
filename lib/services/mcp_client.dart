import 'dart:convert';
import 'package:http/http.dart' as http;

class McpClient {
  final String baseUrl;
  final http.Client _http = http.Client();

  McpClient({this.baseUrl = 'http://localhost:3333'});

  Future<String> generate(String prompt, {String model = 'gemini-2.0-flash'}) async {
    const maxRetries = 3;
    var delay = const Duration(seconds: 1);
    for (var attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final uri = Uri.parse('$baseUrl/tools/gemini.generate');
        final res = await _http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'prompt': prompt, 'model': model}),
        ).timeout(const Duration(seconds: 30));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body) as Map<String, dynamic>;
          final text = data['text'] as String?;
          if (text != null && text.isNotEmpty) return text;
        }
        if (res.statusCode == 429 || res.statusCode >= 500) {
          await Future.delayed(delay);
          delay = Duration(milliseconds: (delay.inMilliseconds * 1.5).round());
          continue;
        }
        throw Exception('MCP error ${res.statusCode}');
      } catch (e) {
        if (attempt == maxRetries - 1) rethrow;
        await Future.delayed(delay);
        delay = Duration(milliseconds: (delay.inMilliseconds * 1.5).round());
      }
    }
    throw Exception('Max retries reached');
  }
}