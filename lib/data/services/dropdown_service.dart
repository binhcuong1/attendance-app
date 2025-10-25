import 'dart:convert';
import '../../core/api/api_client.dart';

class DropdownService {
  // 🔹 Lấy danh sách chức vụ
  static Future<List<Map<String, dynamic>>> getChucVu() async {
    final res = await ApiClient.get("chucvu");
    print("📥 [ChucVu] Raw response: ${res.body}");

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);

      // Trường hợp API có { success: true, data: [...] }
      final List<dynamic> data =
      decoded is List ? decoded : decoded['data'] ?? [];

      print("✅ [ChucVu] Parsed: $data");

      return data.map((e) {
        final id = e['ma_chuc_vu'];
        return {
          'id': id is int ? id : int.tryParse(id.toString()) ?? 0,
          'ten': e['ten_chuc_vu'] ?? '',
        };
      }).toList();
    } else {
      throw Exception("Không thể tải danh sách chức vụ");
    }
  }

  // 🔹 Lấy danh sách phòng ban
  static Future<List<Map<String, dynamic>>> getPhongBan() async {
    final res = await ApiClient.get("phongban");
    print("📥 [PhongBan] Raw response: ${res.body}");

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      final List<dynamic> data =
      decoded is List ? decoded : decoded['data'] ?? [];

      print("✅ [PhongBan] Parsed: $data");

      return data.map((e) {
        final id = e['ma_phong_ban'];
        return {
          'id': id is int ? id : int.tryParse(id.toString()) ?? 0,
          'ten': e['ten_phong_ban'] ?? '',
        };
      }).toList();
    } else {
      throw Exception("Không thể tải danh sách phòng ban");
    }
  }
}
