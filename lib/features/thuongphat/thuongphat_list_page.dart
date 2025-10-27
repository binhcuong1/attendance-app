import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:attendance_app/data/models/thuongphat_model.dart';
import 'package:attendance_app/data/services/thuongphat_service.dart';
import 'package:attendance_app/features/thuongphat/thuongphat_form_page.dart';

class ThuongPhatListPage extends StatefulWidget {
  const ThuongPhatListPage({Key? key}) : super(key: key);

  @override
  State<ThuongPhatListPage> createState() => _ThuongPhatListPageState();
}

class _ThuongPhatListPageState extends State<ThuongPhatListPage> {
  final _service = ThuongPhatService();
  late Future<List<ThuongPhat>> _futureList;

  @override
  void initState() {
    super.initState();
    _futureList = _service.fetchThuongPhatList();
  }

  Future<void> _refreshData() async {
    setState(() => _futureList = _service.fetchThuongPhatList());
  }

  String _formatDate(DateTime? date) =>
      date == null ? 'Không rõ' : DateFormat('dd/MM/yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách Thưởng / Phạt')),
      body: FutureBuilder<List<ThuongPhat>>(
        future: _futureList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('Chưa có dữ liệu thưởng/phạt.'));
          }
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final tp = list[i];
                final isThuong = tp.loaiTP == 'THUONG';
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(
                      isThuong ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isThuong ? Colors.green : Colors.red,
                      size: 30,
                    ),
                    title: Text(
                      '${isThuong ? "🎉 Thưởng" : "⚠️ Phạt"} - ${(tp.soTien ?? 0).toStringAsFixed(0)}đ',
                      style: TextStyle(
                        color: isThuong ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '👤 Nhân viên: ${tp.tenNhanVien?.isNotEmpty == true ? tp.tenNhanVien : "Không rõ"}\n'
                          '📄 Lý do: ${tp.lyDo ?? "Không có"}\n'
                          '📅 Ngày: ${_formatDate(tp.ngay)}',
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ThuongPhatFormPage()),
          );
          if (result == true) _refreshData();
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
