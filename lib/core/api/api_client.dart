import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_env.dart';

class ApiClient {
  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse("${AppEnv.baseUrl}/$endpoint");
    return await http.get(url, headers: {"Content-Type": "application/json"});
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("${AppEnv.baseUrl}/$endpoint");
    return await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body));
  }

  static Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("${AppEnv.baseUrl}/$endpoint");
    return await http.put(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body));
  }

  static Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse("${AppEnv.baseUrl}/$endpoint");
    return await http.delete(url, headers: {"Content-Type": "application/json"});
  }
}
