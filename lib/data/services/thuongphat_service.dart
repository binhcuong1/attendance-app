import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/thuongphat_model.dart';  // ✅ đường dẫn chuẩn hơn
import '../../core/config/app_env.dart';  // ✅ vẫn dùng AppEnv đúng vị trí

class ThuongPhatService {
  final String baseUrl = AppEnv.baseUrl;

  // ✅ Lấy danh sách thưởng/phạt
  Future<List<ThuongPhat>> fetchThuongPhatList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/thuongphat'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ThuongPhat.fromJson(json)).toList();
      } else {
        if (kDebugMode) {
          debugPrint('⚠️ Lỗi API: ${response.statusCode}, body: ${response.body}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Lỗi khi lấy danh sách thưởng/phạt: $e');
      return [];
    }
  }

  Future<void> create(ThuongPhat tp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/thuongphat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tp.toJson()),
      );
      if (response.statusCode != 201) {
        throw Exception('Thêm thất bại: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Lỗi khi thêm thưởng/phạt: $e');
    }
  }

  Future<void> update(ThuongPhat tp) async {
    if (tp.maThuongPhat == null) return;
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/thuongphat/${tp.maThuongPhat}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tp.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Cập nhật thất bại: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Lỗi khi cập nhật thưởng/phạt: $e');
    }
  }
}
