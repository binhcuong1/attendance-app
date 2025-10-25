import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_env.dart';

class ApiClient {
  final http.Client _client;
  final String baseUrl;

  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        baseUrl = baseUrl ?? AppEnv.baseUrl;

  Future<dynamic> get(String endpoint) async {
    final r = await _client.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
    );
    return _handle(r);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final r = await _client.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _handle(r);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final r = await _client.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _handle(r);
  }

  Future<dynamic> delete(String endpoint) async {
    final r = await _client.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
    );
    return _handle(r);
  }

  dynamic _handle(http.Response r) {
    if (r.statusCode >= 200 && r.statusCode < 300) {
      return r.body.isEmpty ? null : jsonDecode(r.body);
    }
    throw Exception('API ${r.statusCode}: ${r.body}');
  }

  void close() => _client.close();
}
