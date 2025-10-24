import '../core/api/api_client.dart';

class ThuongPhatService {
  static Future<List<dynamic>> getAll() async {
    return await ApiClient.get('thuongphat');
  }

  static Future<List<dynamic>> getByNhanVien(int id) async {
    return await ApiClient.get('thuongphat/nhan-vien/$id');
  }

  static Future<dynamic> getThongKe(int id) async {
    return await ApiClient.get('thuongphat/thong-ke/$id');
  }

  static Future<bool> create(Map<String, dynamic> data) async {
    await ApiClient.post('thuongphat', data);
    return true;
  }

  static Future<bool> update(int id, Map<String, dynamic> data) async {
    await ApiClient.put('thuongphat/$id', data);
    return true;
  }

  static Future<bool> delete(int id) async {
    await ApiClient.delete('thuongphat/$id');
    return true;
  }
}
