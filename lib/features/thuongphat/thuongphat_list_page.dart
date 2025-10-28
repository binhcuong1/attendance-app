// ... import hiện có của bạn
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
  late Future<List<ThuongPhat>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchThuongPhatList();
  }

  Future<void> _reload() async {
    setState(() {
      _future = _service.fetchThuongPhatList();
    });
  }

  String _fmtDate(DateTime? d) =>
      d == null ? 'Không rõ' : DateFormat('dd/MM/yyyy').format(d);

  Future<void> _edit(ThuongPhat tp) async {
    final ok = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ThuongPhatFormPage(initial: tp)),
    );
    if (ok == true) _reload();
  }

  Future<void> _delete(ThuongPhat tp) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa thưởng/phạt'),
        content: Text('Bạn chắc chắn muốn xóa bản ghi #${tp.maThuongPhat}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
        ],
      ),
    );
    if (yes == true && tp.maThuongPhat != null) {
      try {
        await _service.delete(tp.maThuongPhat!);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa')),
        );
        _reload();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa thất bại: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách Thưởng / Phạt')),
      body: FutureBuilder<List<ThuongPhat>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Lỗi: ${snap.error}'));
          }
          final list = snap.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('Chưa có bản ghi.'));
          }
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final tp = list[i];
                final isThuong = tp.loaiTP == 'THUONG';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      isThuong ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isThuong ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      '${isThuong ? "🎉 Thưởng" : "⚠️ Phạt"} - ${(tp.soTien ?? 0).toStringAsFixed(0)}đ',
                      style: TextStyle(
                        color: isThuong ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '👤 Nhân viên: ${tp.tenNhanVien ?? "Không rõ"}\n'
                          '📄 Lý do: ${tp.lyDo ?? "Không có"}\n'
                          '📅 Ngày: ${_fmtDate(tp.ngay)}',
                    ),
                    // ✅ THÊM: menu Sửa/Xóa, không phá UI
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) {
                        if (v == 'edit') _edit(tp);
                        if (v == 'delete') _delete(tp);
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Sửa')),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Xóa', style: TextStyle(color: Colors.red)),
                        ),
                      ],
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
          final ok = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ThuongPhatFormPage()),
          );
          if (ok == true) _reload();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
