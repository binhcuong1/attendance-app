import 'package:flutter/material.dart';
import '../models/nhan_vien.dart';
import '../Services/nhan_vien_service.dart';

class NhanVienListScreen extends StatefulWidget {
  const NhanVienListScreen({super.key});

  @override
  State<NhanVienListScreen> createState() => _NhanVienListScreenState();
}

class _NhanVienListScreenState extends State<NhanVienListScreen> {
  List<NhanVien> _items = [];
  bool _loading = false;

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await NhanVienService.getAll();
    _items = data.map((json) => NhanVien.fromJson(json)).toList();
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
      appBar: AppBar(title: const Text('Danh sách Nhân viên')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, i) {
          final nv = _items[i];
          return ListTile(
            title: Text(nv.tenNhanVien),
            subtitle: Text('${nv.email ?? ''} | ${nv.sdt ?? ''}'),
            trailing: Text('Mã: ${nv.maNhanVien}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/addNhanVien');
          _load(); // load lại danh sách sau khi thêm mới
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

