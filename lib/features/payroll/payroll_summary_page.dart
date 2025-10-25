import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/payroll_provider.dart';
import '../../core/utils/money_format.dart';
import 'payroll_detail_page.dart';
import 'payroll_filter_widget.dart';

class PayrollSummaryPage extends StatefulWidget {
  const PayrollSummaryPage({Key? key}) : super(key: key);

  @override
  State<PayrollSummaryPage> createState() => _PayrollSummaryPageState();
}

class _PayrollSummaryPageState extends State<PayrollSummaryPage> {
  int _thang = DateTime.now().month;
  int _nam = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PayrollProvider>(context, listen: false)
          .fetchPayroll(_thang, _nam);
    });
  }

  @override
  Widget build(BuildContext context) {
    final payrollProvider = Provider.of<PayrollProvider>(context);
    final payrolls = payrollProvider.payrolls;
    final loading = payrollProvider.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Bảng lương nhân viên')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            PayrollFilterWidget(
              thang: _thang,
              nam: _nam,
              onChanged: (t, n) {
                setState(() {
                  _thang = t;
                  _nam = n;
                });
                payrollProvider.fetchPayroll(_thang, _nam);
              },
              onCalc: () => payrollProvider.calcAll(_thang, _nam),
              onLock: () => payrollProvider.lockMonth(_thang, _nam),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildTable(context, payrolls),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<dynamic> payrolls) {
    if (payrolls.isEmpty) {
      return const Center(child: Text('Không có dữ liệu bảng lương.'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Mã NV')),
          DataColumn(label: Text('Họ tên')),
          DataColumn(label: Text('Tổng lương')),
          DataColumn(label: Text('Khấu trừ')),
          DataColumn(label: Text('Thực lĩnh')),
          DataColumn(label: Text('Trạng thái')),
          DataColumn(label: Text('Chi tiết')),
        ],
        rows: payrolls.map((p) {
          final daChot = p['da_chot'] == 1;
          return DataRow(cells: [
            DataCell(Text(p['ma_nhan_vien'].toString())),
            DataCell(Text(p['ten_nhan_vien'] ?? '-')),
            DataCell(Text(MoneyFormat.vnd(p['tong_luong']))),
            DataCell(Text(MoneyFormat.vnd(p['khau_tru']))),
            DataCell(Text(
              MoneyFormat.vnd(p['thuc_linh']),
              style: const TextStyle(fontWeight: FontWeight.w600),
            )),
            DataCell(Text(
              daChot ? '✅ Đã chốt' : '🕓 Chưa chốt',
              style: TextStyle(color: daChot ? Colors.green : Colors.orange),
            )),
            DataCell(
              TextButton(
                child: const Text('Xem'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PayrollDetailPage(
                        maNhanVien: p['ma_nhan_vien'],
                        thang: _thang,
                        nam: _nam,
                      ),
                    ),
                  );
                },
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }
}
