import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';

class EmployeeService {
  // URL API - Sửa lại cho đúng
  final String baseUrl = "http://192.168.1.5:3000/api/nhan-vien";
  // Dùng cho thiết bị thật: "http://192.168.1.100:3000/api/nhan-vien"

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // Lấy danh sách tất cả nhân viên
  Future<List<Employee>> getAllEmployees() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
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

  // Lấy thông tin một nhân viên theo ID
  Future<Employee> getEmployeeById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
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

  // Thêm nhân viên mới
  Future<Employee> createEmployee(Employee employee) async {
    try {
      final requestBody = json.encode(employee.toJson());
      print('Creating employee with data: $requestBody');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: requestBody,
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

  // Cập nhật thông tin nhân viên
  Future<Employee> updateEmployee(String id, Employee employee) async {
    try {
      final requestBody = json.encode(employee.toJson());
      print('Updating employee $id with data: $requestBody');

      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
        body: requestBody,
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

  // Xóa nhân viên
  Future<bool> deleteEmployee(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
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

  // Lấy danh sách chức vụ
  Future<List<ChucVu>> getChucVu() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/danh-muc/chuc-vu'),
        headers: headers,
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

  // Lấy danh sách phòng ban
  Future<List<PhongBan>> getPhongBan() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/danh-muc/phong-ban'),
        headers: headers,
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
}