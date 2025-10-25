import 'package:flutter/material.dart';
import '../data/services/payroll_service.dart';

class PayrollProvider extends ChangeNotifier {
  final PayrollService _service = PayrollService();

  bool loading = false;
  List<dynamic> payrolls = [];

  Future<void> fetchPayroll(int thang, int nam) async {
    loading = true;
    notifyListeners();
    try {
      payrolls = await _service.getMonthly(thang, nam);
    } catch (e) {
      debugPrint('Lỗi fetchPayroll: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> calcAll(int thang, int nam) async {
    await _service.calculateAll(thang: thang, nam: nam);
    await fetchPayroll(thang, nam);
  }

  Future<void> lockMonth(int thang, int nam) async {
    await _service.lockMonth(thang, nam);
    await fetchPayroll(thang, nam);
  }
}
