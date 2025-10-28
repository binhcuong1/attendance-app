import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeService {
  final String baseUrl = '${dotenv.env['BASE_URL']}/nhan-vien';

  // ============================================================
  // 🔹 Lấy token từ SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ============================================================
  // 🔹 Hàm build headers động (luôn kèm token nếu có)
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    final headers = {'Content-Type': 'application/json'};

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // ============================================================
  // 🔹 GET ALL EMPLOYEES
  Future<List<Employee>> getAllEmployees() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: await _getHeaders(),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> employeeList = data['data'];
          return employeeList.map((json) => Employee.fromJson(json)).toList();
        }
      }
      throw Exception('Không thể tải danh sách nhân viên');
    } catch (e) {
      print('Error in getAllEmployees: $e');
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // ============================================================
  // 🔹 GET ONE EMPLOYEE BY ID
  Future<Employee> getEmployeeById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Employee.fromJson(data['data']);
        }
      }
      throw Exception('Không tìm thấy nhân viên');
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // ============================================================
  // 🔹 CREATE EMPLOYEE
  Future<Employee> createEmployee(Employee employee) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: await _getHeaders(),
        body: json.encode(employee.toJson()),
      );

      print('Create response status: ${response.statusCode}');
      print('Create response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Employee.fromJson(data['data']);
        }
      }

      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Không thể thêm nhân viên');
    } catch (e) {
      print('Error in createEmployee: $e');
      throw Exception('Lỗi: $e');
    }
  }

  // ============================================================
  // 🔹 UPDATE EMPLOYEE
  Future<Employee> updateEmployee(String id, Employee employee) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: await _getHeaders(),
        body: json.encode(employee.toJson()),
      );

      print('Update response status: ${response.statusCode}');
      print('Update response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Employee.fromJson(data['data']);
        }
      }

      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Không thể cập nhật nhân viên');
    } catch (e) {
      print('Error in updateEmployee: $e');
      throw Exception('Lỗi: $e');
    }
  }

  // ============================================================
  // 🔹 DELETE EMPLOYEE
  Future<bool> deleteEmployee(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: await _getHeaders(),
      );

      print('Delete response status: ${response.statusCode}');
      print('Delete response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      throw Exception('Không thể xóa nhân viên');
    } catch (e) {
      print('Error in deleteEmployee: $e');
      throw Exception('Lỗi: $e');
    }
  }

  // ============================================================
  // 🔹 LẤY DANH SÁCH CHỨC VỤ
  Future<List<ChucVu>> getChucVu() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/danh-muc/chuc-vu'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> list = data['data'];
          return list.map((json) => ChucVu.fromJson(json)).toList();
        }
      }
      throw Exception('Không thể tải danh sách chức vụ');
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  // ============================================================
  // 🔹 LẤY DANH SÁCH PHÒNG BAN
  Future<List<PhongBan>> getPhongBan() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/danh-muc/phong-ban'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> list = data['data'];
          return list.map((json) => PhongBan.fromJson(json)).toList();
        }
      }
      throw Exception('Không thể tải danh sách phòng ban');
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  // ============================================================
// 🔹 GỬI OTP XÁC NHẬN XÓA NHÂN VIÊN
  Future<bool> sendDeleteOtp(String empId) async {
    try {
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        throw Exception('⚠️ Chưa có token đăng nhập');
      }

      // 🟢 Gửi OTP luôn về admin (id = 1)
      final otpUrl = '${dotenv.env['BASE_URL']}/otp/send-delete/1';

      print('📡 Gửi OTP xác nhận xóa cho nhân viên ID: $empId');
      print('🧩 Token: $token');

      final response = await http.post(
        Uri.parse(otpUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // gửi kèm id nhân viên cần xóa trong body cho BE nếu muốn biết context
        body: json.encode({'targetId': empId}),
      );

      print('📩 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['ok'] == true;
      }
      return false;
    } catch (e) {
      print('❌ Lỗi gửi OTP: $e');
      return false;
    }
  }

// ============================================================
// 🔹 XÁC MINH MÃ OTP
  Future<bool> verifyDeleteOtp(String empId, String otp) async {
    try {
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        throw Exception('⚠️ Chưa có token đăng nhập');
      }

      final verifyUrl = '${dotenv.env['BASE_URL']}/otp/verify-delete/$empId';

      print('📡 Xác minh OTP cho nhân viên ID: $empId');
      print('🔹 Token: $token');
      print('🔑 OTP nhập vào: $otp');

      final response = await http.post(
        Uri.parse(verifyUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'code': otp}),
      );

      print('✅ Verify OTP status: ${response.statusCode}');
      print('📄 Verify OTP body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['ok'] == true;
      }
      return false;
    } catch (e) {
      print('❌ Lỗi xác minh OTP: $e');
      return false;
    }
  }
}
