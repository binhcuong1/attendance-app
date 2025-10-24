import 'package:flutter/material.dart';

// Import tất cả các màn hình cần thiết
import 'screens/home_screen.dart';
import 'screens/nhanvien_list_screen.dart';
import 'screens/nhanvien_form_screen.dart';
import 'screens/thuongphat_list_screen.dart';
import 'screens/thuongphat_form_screen.dart';

void main() {
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Chấm Công',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueAccent,
      ),
      // Màn hình khởi đầu
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/nhanVien': (context) => const NhanVienListScreen(),
        '/addNhanVien': (context) => const NhanVienFormScreen(),
        '/thuongPhat': (context) => const ThuongPhatListScreen(),
        '/addThuongPhat': (context) => const ThuongPhatFormScreen(),
      },
    );
  }
}
