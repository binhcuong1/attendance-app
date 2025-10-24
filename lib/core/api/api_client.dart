import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // Android Emulator

  // GET
  static Future<dynamic> get(String endpoint) async {
    final res = await http.get(Uri.parse('$baseUrl/$endpoint'));
    _checkStatus(res);
    return jsonDecode(res.body);
  }

  // POST
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    _checkStatus(res);
    return jsonDecode(res.body);
  }

  // PUT
  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    _checkStatus(res);
    return jsonDecode(res.body);
  }

  // DELETE
  static Future<void> delete(String endpoint) async {
    final res = await http.delete(Uri.parse('$baseUrl/$endpoint'));
    _checkStatus(res);
  }

  static void _checkStatus(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Lỗi API: ${res.statusCode} - ${res.body}');
    }
  }
}
