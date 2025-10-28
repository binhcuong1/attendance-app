import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/data/models/user_model.dart';

class AuthService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<UserModel?> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login');
      print("🔗 Gửi request tới: $url");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print("🟩 Response code: ${response.statusCode}");
      print("🟦 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ Khởi tạo SharedPreferences
        final prefs = await SharedPreferences.getInstance();

        // ✅ BE trả accessToken ngay cấp 1
        final token = data['accessToken'];
        print("🟨 accessToken từ BE: $token");

        if (token != null && token.toString().isNotEmpty) {
          await prefs.setString('token', token.toString());
          print('📦 ĐÃ LƯU token vào SharedPreferences: $token');
        } else {
          print('⚠️ accessToken RỖNG hoặc KHÔNG TỒN TẠI');
        }

        // ✅ Thông tin user
        final userData = data['user'] ?? {};
        print('👤 Dữ liệu user từ BE: $userData');

        if (userData.isNotEmpty) {
          await prefs.setString('user_email', userData['email'] ?? '');
          await prefs.setString('user_name', userData['name'] ?? '');
        }

        print('✅ Hoàn tất lưu token & user info!');
        return UserModel.fromJson(Map<String, dynamic>.from(userData));
      } else {
        print('❌ Lỗi BE: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('💥 Lỗi kết nối hoặc parse JSON: $e');
      return null;
    }
  }
}
