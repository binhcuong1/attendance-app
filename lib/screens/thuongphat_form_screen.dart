import 'package:flutter/material.dart';
import '../models/thuong_phat.dart';
import '../models/nhan_vien.dart';
import '../Services/thuong_phat_service.dart';
import '../Services/nhan_vien_service.dart';

class ThuongPhatFormScreen extends StatefulWidget {
  const ThuongPhatFormScreen({super.key});

  @override
  State<ThuongPhatFormScreen> createState() => _ThuongPhatFormScreenState();
}

class _ThuongPhatFormScreenState extends State<ThuongPhatFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ngayCtrl = TextEditingController();
  final _soTienCtrl = TextEditingController();
  final _lyDoCtrl = TextEditingController();
  String _loaiTP = 'THUONG';

  // Danh sách nhân viên và nhân viên được chọn
  List<NhanVien> _nhanVienList = [];
  NhanVien? _selectedNhanVien;
  bool _loadingNV = false;

  @override
  void initState() {
    super.initState();
    _loadNhanVien();
  }

  Future<void> _loadNhanVien() async {
    setState(() => _loadingNV = true);
    final data = await NhanVienService.getAll();
    _nhanVienList = data.map((json) => NhanVien.fromJson(json)).toList();
    setState(() => _loadingNV = false);
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedNhanVien == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn nhân viên')),
        );
        return;
      }

      final tp = ThuongPhat(
        maThuongPhat: 0,
        maNhanVien: _selectedNhanVien!.maNhanVien,
        loaiTP: _loaiTP,
        soTien: double.tryParse(_soTienCtrl.text) ?? 0.0,
        ngay: _ngayCtrl.text,
        lyDo: _lyDoCtrl.text,
      );

      await ThuongPhatService.create(tp.toJson());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm Thưởng/Phạt thành công!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm Thưởng/Phạt')),
      body: _loadingNV
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Dropdown chọn nhân viên
              DropdownButtonFormField<NhanVien>(
                value: _selectedNhanVien,
                items: _nhanVienList.map((nv) {
                  return DropdownMenuItem<NhanVien>(
                    value: nv,
                    child: Text('${nv.tenNhanVien} (Mã: ${nv.maNhanVien})'),
                  );
                }).toList(),
                onChanged: (nv) => setState(() => _selectedNhanVien = nv),
                decoration: const InputDecoration(
                  labelText: 'Chọn Nhân viên',
                  prefixIcon: Icon(Icons.people_alt),
                ),
                validator: (v) =>
                v == null ? 'Vui lòng chọn nhân viên' : null,
              ),
              const SizedBox(height: 16),

              // Dropdown chọn loại thưởng/phạt
              DropdownButtonFormField<String>(
                value: _loaiTP,
                items: const [
                  DropdownMenuItem(value: 'THUONG', child: Text('Thưởng')),
                  DropdownMenuItem(value: 'PHAT', child: Text('Phạt')),
                ],
                onChanged: (v) => setState(() => _loaiTP = v!),
                decoration: const InputDecoration(
                  labelText: 'Loại',
                  prefixIcon: Icon(Icons.category_rounded),
                ),
              ),
              const SizedBox(height: 16),

              // Nhập số tiền
              TextFormField(
                controller: _soTienCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  prefixIcon: Icon(Icons.monetization_on),
                ),
                validator: (v) => v!.isEmpty ? 'Nhập số tiền' : null,
              ),
              const SizedBox(height: 16),

              // Nhập ngày
              TextFormField(
                controller: _ngayCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ngày (yyyy-MM-dd)',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (v) => v!.isEmpty ? 'Nhập ngày' : null,
              ),
              const SizedBox(height: 16),

              // Nhập lý do
              TextFormField(
                controller: _lyDoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Lý do',
                  prefixIcon: Icon(Icons.edit_note),
                ),
              ),
              const SizedBox(height: 24),

              // Nút lưu
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Lưu'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
