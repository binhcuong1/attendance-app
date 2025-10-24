import 'package:flutter/material.dart';
import 'employee_management_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToEmployeeManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmployeeManagementPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header với search bar
            _buildHeader(),

            // Menu grid
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildMenuGrid(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0066FF), Color(0xFF0052CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Color(0xFF0066FF)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm nhanh',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 26,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
        children: [
          _buildMenuItem(
            icon: Icons.person,
            label: 'Hồ sơ',
            color: const Color(0xFF0066FF),
            onTap: null,
          ),
          _buildMenuItem(
            icon: Icons.emoji_events,
            label: 'Bảng lương',
            color: const Color(0xFFFF9500),
            onTap: null,
          ),
          _buildMenuItem(
            icon: Icons.access_time,
            label: 'Chấm công',
            color: const Color(0xFF00C853),
            onTap: null,
          ),
          _buildMenuItem(
            icon: Icons.nights_stay,
            label: 'Nghỉ phép',
            color: const Color(0xFF1A237E),
            onTap: null,
          ),
          _buildMenuItem(
            icon: Icons.people,
            label: 'QLNV',
            color: const Color(0xFF9C27B0),
            onTap: _navigateToEmployeeManagement,
          ),
          _buildMenuItem(
            icon: Icons.adjust,
            label: 'Mục tiêu',
            color: const Color(0xFFE91E63),
            onTap: null,
          ),
          _buildMenuItem(
            icon: Icons.cake,
            label: 'Sự nghiệp',
            color: const Color(0xFFFF5252),
            onTap: null,
          ),
          _buildMenuItem(
            icon: Icons.label,
            label: 'Quy định',
            color: const Color(0xFFFF6D00),
            onTap: null,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () => print('Đã nhấn vào $label'),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0066FF),
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Lịch',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline, size: 32),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder_outlined),
          label: 'Công ty',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apps),
          label: 'Bảng tin',
        ),
      ],
    );
  }
}