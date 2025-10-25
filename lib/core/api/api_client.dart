import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_env.dart';

class ApiClient {
  final _client = http.Client();

  Future<dynamic> get(String endpoint) async {
    final url = '${AppEnv.baseUrl}/$endpoint';
    final response = await _client.get(Uri.parse(url));
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = '${AppEnv.baseUrl}/$endpoint';
    final response = await _client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response r) {
    if (r.statusCode >= 200 && r.statusCode < 300) {
      return jsonDecode(r.body);
    } else {
      throw Exception('Lỗi API ${r.statusCode}: ${r.body}');
    }
  }
}
