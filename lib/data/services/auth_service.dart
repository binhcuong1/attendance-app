import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

class AuthService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? ''; // Lấy từ .env

  Future<UserModel> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    print("🔗 Gửi request tới: $url"); // debug

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      print("❌ Lỗi BE: ${response.body}");
      throw Exception('Đăng nhập thất bại (${response.statusCode})');
    }
  }
}
