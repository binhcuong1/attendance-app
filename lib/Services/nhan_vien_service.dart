import '../core/api/api_client.dart';

class NhanVienService {
  static Future<List<dynamic>> getAll() async {
    return await ApiClient.get('nhanvien');
  }

  static Future<dynamic> getById(int id) async {
    return await ApiClient.get('nhanvien/$id');
  }

  static Future<dynamic> create(Map<String, dynamic> data) async {
    return await ApiClient.post('nhanvien', data);
  }

  static Future<dynamic> update(int id, Map<String, dynamic> data) async {
    return await ApiClient.put('nhanvien/$id', data);
  }

  static Future<void> delete(int id) async {
    await ApiClient.delete('nhanvien/$id');
  }
}
