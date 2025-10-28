import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmployeeService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  // ===== NHÂN VIÊN =====
  Future<List<dynamic>> getEmployees() async {
    final res = await http.get(Uri.parse('$baseUrl/nhanvien'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Không thể tải danh sách nhân viên');
  }

  Future<void> addEmployee(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/nhan-vien'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (res.statusCode != 201) throw Exception('Thêm nhân viên thất bại');
  }

  Future<void> updateEmployee(int id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('$baseUrl/nhan-vien/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (res.statusCode != 200) throw Exception('Cập nhật nhân viên thất bại');
  }

  Future<void> deleteEmployee(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/nhan-vien/$id'));
    if (res.statusCode != 200) throw Exception('Xóa nhân viên thất bại');
  }

  // ===== CHỨC VỤ =====
  Future<List<dynamic>> getChucVu() async {
    final res = await http.get(Uri.parse('$baseUrl/chucvu'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Không thể tải danh sách chức vụ');
  }

  Future<void> addChucVu(String tenChucVu, double heSoLuong) async {
    final res = await http.post(
      Uri.parse('$baseUrl/chucvu'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ten_chuc_vu': tenChucVu, 'he_so_luong': heSoLuong}),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Không thể thêm chức vụ');
    }
  }

  Future<void> updateChucVu(int id, String tenChucVu, double heSoLuong) async {
    final res = await http.put(
      Uri.parse('$baseUrl/chucvu/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ten_chuc_vu': tenChucVu, 'he_so_luong': heSoLuong}),
    );
    if (res.statusCode != 200) throw Exception('Cập nhật chức vụ thất bại');
  }

  Future<void> deleteChucVu(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/chucvu/$id'));
    if (res.statusCode != 200) throw Exception('Xóa chức vụ thất bại');
  }

  // ===== PHÒNG BAN =====
  Future<List<dynamic>> getPhongBan() async {
    final res = await http.get(Uri.parse('$baseUrl/phongban'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Không thể tải danh sách phòng ban');
  }

  Future<void> addPhongBan(String tenPhongBan) async {
    final res = await http.post(
      Uri.parse('$baseUrl/phongban'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ten_phong_ban': tenPhongBan}),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Không thể thêm phòng ban');
    }
  }

  Future<void> updatePhongBan(int id, String tenPhongBan) async {
    final res = await http.put(
      Uri.parse('$baseUrl/phongban/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ten_phong_ban': tenPhongBan}),
    );
    if (res.statusCode != 200) throw Exception('Cập nhật phòng ban thất bại');
  }

  Future<void> deletePhongBan(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/phongban/$id'));
    if (res.statusCode != 200) throw Exception('Xóa phòng ban thất bại');
  }
}
