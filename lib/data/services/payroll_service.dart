import 'package:attendance_app/core/api/api_client.dart';

class PayrollService {
  final ApiClient _api = ApiClient();

  Future<Map<String, dynamic>> calculateAll({required int thang, required int nam}) async {
    return await _api.post('bangluong/calc-all', {'thang': thang, 'nam': nam});
  }

  Future<List<dynamic>> getMonthly(int thang, int nam) async {
    final res = await _api.get('bangluong/monthly/$thang/$nam');
    return List<Map<String, dynamic>>.from(res['data'] ?? []);
  }

  Future<Map<String, dynamic>> getDetail(int id, int thang, int nam) async {
    final res = await _api.get('bangluong/detail/$id/$thang/$nam');
    return Map<String, dynamic>.from(res['data'] ?? {});
  }

  // ✅ CHỐT LƯƠNG
  Future<Map<String, dynamic>> lockMonth(int thang, int nam) async {
    return await _api.post('bangluong/lock', {'thang': thang, 'nam': nam});
  }
}
