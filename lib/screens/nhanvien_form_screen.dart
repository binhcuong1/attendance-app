import 'package:flutter/material.dart';
import '../Services/nhan_vien_service.dart';

class NhanVienFormScreen extends StatefulWidget {
  const NhanVienFormScreen({super.key});

  @override
  State<NhanVienFormScreen> createState() => _NhanVienFormScreenState();
}

class _NhanVienFormScreenState extends State<NhanVienFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tenCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _sdtCtrl = TextEditingController();
  final _maChucVuCtrl = TextEditingController();
  final _maPhongBanCtrl = TextEditingController();

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final nvData = {
        "ma_chuc_vu": int.tryParse(_maChucVuCtrl.text) ?? 1,
        "ma_phong_ban": int.tryParse(_maPhongBanCtrl.text) ?? 1,
        "ten_nhan_vien": _tenCtrl.text,
        "email": _emailCtrl.text,
        "sdt": _sdtCtrl.text,
      };

      await NhanVienService.create(nvData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm nhân viên thành công!')),
        );
        Navigator.pop(context);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm nhân viên')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tenCtrl,
                decoration: const InputDecoration(labelText: 'Tên nhân viên'),
                validator: (v) => v!.isEmpty ? 'Nhập tên' : null,
              ),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _sdtCtrl,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
              ),
              TextFormField(
                controller: _maChucVuCtrl,
                decoration: const InputDecoration(labelText: 'Mã chức vụ'),
              ),
              TextFormField(
                controller: _maPhongBanCtrl,
                decoration: const InputDecoration(labelText: 'Mã phòng ban'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
