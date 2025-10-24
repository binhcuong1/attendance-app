import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ca_model.dart';

class CaService {
  final String baseUrl = 'http://10.0.2.2:3000/api/calamviec';

  Future<List<CaModel>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded is List ? decoded : decoded['data'] ?? [];
      return data.map((e) => CaModel.fromJson(e)).toList();

    } else {
      throw Exception("Lỗi tải danh sách ca làm việc");
    }
  }

  Future<void> add(CaModel ca) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ca.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Lỗi thêm ca làm việc");
    }
  }

  Future<void> update(CaModel ca) async {
    final url = Uri.parse('$baseUrl/${ca.maCaLamViec}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ca.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Lỗi cập nhật ca làm việc");
    }
  }

  Future<void> delete(int id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception("Lỗi xóa ca làm việc");
    }
  }
}
