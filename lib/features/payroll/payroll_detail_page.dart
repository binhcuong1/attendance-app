import 'package:flutter/material.dart';
import '../../data/services/payroll_service.dart';
import '../../core/utils/money_format.dart';

class PayrollDetailPage extends StatefulWidget {
  final int maNhanVien, thang, nam;

  const PayrollDetailPage({
    super.key,
    required this.maNhanVien,
    required this.thang,
    required this.nam,
  });

  @override
  State<PayrollDetailPage> createState() => _PayrollDetailPageState();
}

class _PayrollDetailPageState extends State<PayrollDetailPage> {
  Map<String, dynamic>? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await PayrollService()
        .getDetail(widget.maNhanVien, widget.thang, widget.nam);
    setState(() {
      data = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final tpList = List<Map<String, dynamic>>.from(data?['thuong_phat'] ?? []);

    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết ${data?['ten_nhan_vien']}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Tháng: ${widget.thang}/${widget.nam}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            ..._rows(),
            const Divider(),
            const Text('Chi tiết thưởng / phạt:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...tpList.map((e) => ListTile(
              title: Text('${e['ngay']} - ${e['loai_tp']}'),
              subtitle: Text(e['ly_do'] ?? ''),
              trailing: Text(MoneyFormat.vnd(e['so_tien'])),
            )),
          ],
        ),
      ),
    );
  }

  List<Widget> _rows() {
    final map = data ?? {};
    final fields = [
      ['Lương cơ bản', map['luong_co_so']],
      ['Tổng phụ cấp', map['tong_phu_cap']],
      ['Tổng thưởng', map['tong_thuong']],
      ['Tổng phạt', map['tong_phat']],
      ['Làm thêm giờ', map['tien_lam_them']],
      ['Tổng tạm ứng', map['tong_tam_ung']],
      ['Tổng lương (Gross)', map['tong_luong']],
      ['Thực lĩnh (Net)', map['thuc_linh']],
    ];

    return fields.map((f) {
      final label = f[0].toString();
      final isNet = label.contains('Net');
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              MoneyFormat.vnd(f[1]),
              style: TextStyle(
                fontWeight: isNet ? FontWeight.bold : FontWeight.normal,
                color: isNet ? Colors.green.shade700 : null,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
