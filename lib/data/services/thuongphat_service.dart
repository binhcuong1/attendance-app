import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/app_env.dart';
import '../models/thuongphat_model.dart';

class ThuongPhatService {
  final String baseUrl = AppEnv.baseUrl;

  Future<List<ThuongPhat>> fetchThuongPhatList() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/thuongphat'));
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((e) => ThuongPhat.fromJson(e)).toList();
      } else {
        throw Exception('API ${res.statusCode}: ${res.body}');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách thưởng/phạt: $e');
    }
  }

  Future<void> create(ThuongPhat tp) async {
    final body = {
      'ma_nhan_vien': tp.maNhanVien,
      'loai_tp': tp.loaiTP,
      'so_tien': tp.soTien,
      'ly_do': tp.lyDo,
      'ngay': tp.ngay?.toIso8601String(),
    };

    final res = await http.post(
      Uri.parse('$baseUrl/thuongphat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode != 201) {
      throw Exception('Thêm thưởng/phạt thất bại: ${res.body}');
    }
  }

  Future<void> update(ThuongPhat tp) async {
    if (tp.maThuongPhat == null) throw Exception('Thiếu mã để cập nhật');

    final body = {
      'ma_nhan_vien': tp.maNhanVien,
      'loai_tp': tp.loaiTP,
      'so_tien': tp.soTien,
      'ly_do': tp.lyDo,
      'ngay': tp.ngay?.toIso8601String(),
    };

    final res = await http.put(
      Uri.parse('$baseUrl/thuongphat/${tp.maThuongPhat}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception('Cập nhật thất bại: ${res.body}');
    }
  }

  Future<void> delete(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/thuongphat/$id'));
    if (res.statusCode != 200) {
      throw Exception('Xóa thất bại: ${res.body}');
    }
  }
}
