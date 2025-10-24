import 'package:flutter/material.dart';
import '../models/thuong_phat.dart';
import '../Services/thuong_phat_service.dart';

class ThuongPhatListScreen extends StatefulWidget {
  const ThuongPhatListScreen({super.key});

  @override
  State<ThuongPhatListScreen> createState() => _ThuongPhatListScreenState();
}

class _ThuongPhatListScreenState extends State<ThuongPhatListScreen> {
  List<ThuongPhat> _items = [];
  bool _loading = false;

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await ThuongPhatService.getAll();
    _items = data.map((e) => ThuongPhat.fromJson(e)).toList();
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách Thưởng/Phạt')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, i) {
          final tp = _items[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(
                tp.loaiTP == 'THUONG'
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                color: tp.loaiTP == 'THUONG'
                    ? Colors.green
                    : Colors.red,
              ),
              title: Text(
                '${tp.tenNhanVien ?? "NV #${tp.maNhanVien}"} - ${tp.soTien.toStringAsFixed(0)}đ',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${tp.loaiTP} • Ngày: ${tp.ngay}\nLý do: ${tp.lyDo ?? "Không có"}',
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/addThuongPhat');
          if (result == true) _load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
