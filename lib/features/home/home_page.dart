import 'package:flutter/material.dart';
import 'package:attendance_app/data/models/user_model.dart';
import 'package:attendance_app/features/nhanvien/nhanvien_page.dart';
import 'package:attendance_app/features/ca/ca_page.dart';
import 'package:attendance_app/screens/employee_management_page.dart';
import 'package:attendance_app/features/payroll/payroll_summary_page.dart';
import 'package:attendance_app/features/chat/chat_admin_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendance_app/features/auth/login_page.dart';

// ✅ Import thêm phần thưởng phạt
import 'package:attendance_app/features/thuongphat/thuongphat_list_page.dart';

class HomePage extends StatefulWidget {
  final UserModel user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<String> _titles = ["Trang chủ", "Đăng xuất"];

  Future<void> _logout() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (yes != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_email');
    await prefs.remove('user_name');

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) {
            // 👉 Tab Đăng xuất
            _logout(); // gọi hàm đăng xuất
            return; // đừng đổi _selectedIndex
          }
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            activeIcon: Icon(Icons.logout),
            label: "Đăng xuất",
          ),
        ],
      ),
    );
  }

  // ======= Nội dung từng tab =======
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const Center(child: Text("Đang đăng xuất..."));
      default:
        return const SizedBox();
    }
  }

  // ======= Trang chủ chính =======
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.calendar_today, color: Colors.blue),
              ),
              title: const Text(
                'Lịch sử làm việc',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Thứ 2, 12/07/2021\n10 năm 314 ngày làm việc',
              ),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 20),

          // ===== Lưới icon chức năng =====
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _FeatureIcon(
                Icons.people,
                'Quản lý NV',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmployeeManagementPage(),
                  ),
                ),
              ),
              _FeatureIcon(
                Icons.access_time,
                'Ca làm việc',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CaPage()),
                ),
              ),

              const _FeatureIcon(Icons.check_circle, 'Todo'),
              const _FeatureIcon(Icons.flag, 'Mục tiêu'),
              const _FeatureIcon(Icons.school, 'Sự nghiệp'),
              const _FeatureIcon(Icons.rule, 'Quy định'),

              // ✅ ĐÃ ĐỔI: Giới thiệu → Thưởng phạt
              _FeatureIcon(
                Icons.emoji_events,
                'Thưởng phạt',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ThuongPhatListPage()),
                ),
              ),

              _FeatureIcon(
                Icons.receipt_long,
                'Bảng lương',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PayrollSummaryPage()),
                ),
              ),

              _FeatureIcon(
                Icons.chat,
                'Chat',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatAdminListPage()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======= Widget icon chức năng =======
class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  const _FeatureIcon(this.icon, this.title, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.shade200,
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
