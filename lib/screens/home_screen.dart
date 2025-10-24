import 'package:flutter/material.dart';
import 'nhanvien_list_screen.dart';
import 'thuongphat_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _goToNhanVien(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NhanVienListScreen()),
    );
  }

  void _goToThuongPhat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ThuongPhatListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Nút Quản lý nhân viên
              ElevatedButton.icon(
                onPressed: () => _goToNhanVien(context),
                icon: const Icon(Icons.people_alt_rounded),
                label: const Text(
                  'Quản lý Nhân viên',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                ),
              ),
              const SizedBox(height: 20),
              // Nút Quản lý Thưởng/Phạt
              ElevatedButton.icon(
                onPressed: () => _goToThuongPhat(context),
                icon: const Icon(Icons.attach_money_rounded),
                label: const Text(
                  'Quản lý Thưởng / Phạt',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
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
