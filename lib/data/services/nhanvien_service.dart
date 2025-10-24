import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/config/app_env.dart';
import '../models/nhanvien_model.dart';

class NhanVienService {
  final String _endpoint = "${AppEnv.baseUrl}/nhanvien";

  // 📋 Lấy danh sách nhân viên
  Future<List<NhanVien>> getAll() async {
    final response = await http.get(Uri.parse(_endpoint));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success'] == true) {
        final List data = jsonData['data'];
        return data.map((e) => NhanVien.fromJson(e)).toList();
      } else {
        throw Exception(jsonData['message'] ?? "Không thể tải danh sách nhân viên");
      }
    } else {
      throw Exception("Lỗi server: ${response.statusCode}");
    }
  }

  // ➕ Thêm nhân viên
  Future<void> add(NhanVien nv) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(nv.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Không thể thêm nhân viên");
    }
  }

  // ✏️ Cập nhật nhân viên
  Future<void> update(int id, NhanVien nv) async {
    final response = await http.put(
      Uri.parse("$_endpoint/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(nv.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Không thể cập nhật nhân viên");
    }
  }

  // 🗑️ Xóa nhân viên
  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse("$_endpoint/$id"));
    if (response.statusCode != 200) {
      throw Exception("Không thể xóa nhân viên");
    }
  }
}
