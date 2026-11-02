// lib/features/tools/data/services/github_doc_service.dart
import 'package:http/http.dart' as http;

class GithubDocService {
  static Future<String?> fetchRemoteContent(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Failed to load content (Error code: ${response.statusCode})';
      }
    } catch (e) {
      return 'Network error occurred while fetching content: $e';
    }
  }
}
