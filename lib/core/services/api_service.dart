// lib/core/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<dynamic>> fetchJsonList(String url) async {
    try {
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (decodedData is List) {
          return decodedData;
        } else {
          throw Exception('Invalid response format: Expected a JSON list.');
        }
      } else {
        throw Exception('Server error: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<List<int>> downloadFile(String url) async {
    try {
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception(
            'Failed to download file: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Download error: $e');
    }
  }
}