import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:attendance_app/data/models/thuongphat_model.dart';
import 'package:attendance_app/data/services/thuongphat_service.dart';

class ThuongPhatFormPage extends StatefulWidget {
  const ThuongPhatFormPage({Key? key}) : super(key: key);

  @override
  State<ThuongPhatFormPage> createState() => _ThuongPhatFormPageState();
}

class _ThuongPhatFormPageState extends State<ThuongPhatFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = ThuongPhatService();
  final _nhanVienCtrl = TextEditingController();
  final _soTienCtrl = TextEditingController();
  final _lyDoCtrl = TextEditingController();
  final _ngayCtrl = TextEditingController();
  String? _loaiTP;
  DateTime? _selectedDate;

  Future<void> _chonNgay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _ngayCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _luu() async {
    if (!_formKey.currentState!.validate()) return;
    final tp = ThuongPhat(
      maNhanVien: int.tryParse(_nhanVienCtrl.text),
      loaiTP: _loaiTP,
      soTien: double.tryParse(_soTienCtrl.text),
      lyDo: _lyDoCtrl.text,
      ngay: _selectedDate,
    );
    await _service.create(tp);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Đã thêm thưởng/phạt thành công')),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm Thưởng / Phạt')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nhanVienCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Mã nhân viên',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Bắt buộc nhập' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _loaiTP,
                decoration: const InputDecoration(
                  labelText: 'Loại',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'THUONG', child: Text('Thưởng')),
                  DropdownMenuItem(value: 'PHAT', child: Text('Phạt')),
                ],
                onChanged: (v) => setState(() => _loaiTP = v),
                validator: (v) => v == null ? 'Chọn loại' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _soTienCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Bắt buộc nhập' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lyDoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Lý do',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ngayCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Ngày',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _chonNgay,
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _luu,
                icon: const Icon(Icons.save),
                label: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
