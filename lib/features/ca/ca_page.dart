import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/models/ca_model.dart';
import '../../data/services/ca_service.dart';
import 'package:intl/intl.dart';

class CaPage extends StatefulWidget {
  const CaPage({super.key});

  @override
  State<CaPage> createState() => _CaPageState();
}

class _CaPageState extends State<CaPage> {
  final CaService _service = CaService();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<CaModel> _dsCa = [];
  bool _loading = true;

  final Map<DateTime, List<CaModel>> _events = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final data = await _service.getAll();

    _events.clear();
    for (var ca in data) {
      final ngay = ca.ngayLamViec;
      if (ngay == null || ngay.isEmpty) continue;

      try {
        final date = DateTime.parse(ngay).toLocal();
        final key = DateTime(date.year, date.month, date.day);
        _events.putIfAbsent(key, () => []).add(ca);
      } catch (e) {
        print("⚠️ Lỗi parse ngày: $ngay => $e");
      }
    }

    setState(() {
      _dsCa = data;
      _loading = false;
    });
  }

  List<CaModel> _getCaTheoNgay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  Future<void> _showDialog({CaModel? ca, required DateTime ngay}) async {
    final tenCaCtrl = TextEditingController(text: ca?.tenCa ?? '');
    final gioBDCtrl = TextEditingController(text: ca?.gioBatDau ?? '');
    final gioKTCtrl = TextEditingController(text: ca?.gioKetThuc ?? '');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(ca == null ? 'Thêm ca mới' : 'Chỉnh sửa ca'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tenCaCtrl,
              decoration: const InputDecoration(labelText: 'Tên ca'),
            ),
            TextField(
              controller: gioBDCtrl,
              decoration:
              const InputDecoration(labelText: 'Giờ bắt đầu (HH:mm)'),
            ),
            TextField(
              controller: gioKTCtrl,
              decoration:
              const InputDecoration(labelText: 'Giờ kết thúc (HH:mm)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Hủy"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text(ca == null ? "Thêm" : "Cập nhật"),
            onPressed: () async {
              final newCa = CaModel(
                maCaLamViec: ca?.maCaLamViec ?? 0,
                tenCa: tenCaCtrl.text,
                gioBatDau: gioBDCtrl.text,
                gioKetThuc: gioKTCtrl.text,
                ngayLamViec: DateFormat('yyyy-MM-dd').format(ngay),
              );

              if (ca == null) {
                await _service.add(newCa);
              } else {
                await _service.update(newCa);
              }

              await _loadData();
              if (mounted) setState(() {});
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🕒 Ca làm việc')),
      floatingActionButton: _selectedDay == null
          ? null
          : FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          _showDialog(ngay: _selectedDay!);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          TableCalendar<CaModel>(
            locale: 'vi_VN',
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getCaTheoNgay,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _selectedDay == null
                ? const Center(
              child: Text("👉 Chọn một ngày để xem ca làm việc"),
            )
                : _buildDanhSachCa(_getCaTheoNgay(_selectedDay!)),
          ),
        ],
      ),
    );
  }

  Widget _buildDanhSachCa(List<CaModel> ds) {
    if (ds.isEmpty) {
      return const Center(child: Text("Không có ca nào trong ngày này."));
    }
    return ListView.builder(
      itemCount: ds.length,
      itemBuilder: (_, i) {
        final ca = ds[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(ca.tenCa),
            subtitle: Text("⏰ ${ca.gioBatDau} - ${ca.gioKetThuc}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () => _showDialog(
                    ca: ca,
                    ngay: DateTime.parse(ca.ngayLamViec).toLocal(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _service.delete(ca.maCaLamViec);
                    await _loadData();
                    if (mounted) setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
