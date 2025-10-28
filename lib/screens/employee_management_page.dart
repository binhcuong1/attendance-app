import 'package:flutter/material.dart';
import '../features/auth/otp_verification_page.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';
import 'employee_form_page.dart';

class EmployeeManagementPage extends StatefulWidget {
  const EmployeeManagementPage({Key? key}) : super(key: key);

  @override
  State<EmployeeManagementPage> createState() => _EmployeeManagementPageState();
}

class _EmployeeManagementPageState extends State<EmployeeManagementPage> {
  final EmployeeService _employeeService = EmployeeService();
  List<Employee> employees = [];
  bool isLoading = false;
  String selectedDepartment = 'Tất cả';
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchEmployees() async {
    setState(() => isLoading = true);
    try {
      final data = await _employeeService.getAllEmployees();
      setState(() {
        employees = data;
      });
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ✅ Cập nhật lại flow xoá nhân viên có xác minh OTP
  Future<void> _deleteEmployeeWithOtp(Employee employee) async {
    try {
      // 1️⃣ Gọi API gửi OTP
      final success = await _employeeService.sendDeleteOtp(employee.id);

      if (!success) {
        _showErrorSnackBar('Không thể gửi OTP. Vui lòng thử lại.');
        return;
      }

      // 2️⃣ Chuyển sang trang xác minh OTP
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationPage(employeeId: int.parse(employee.id)),
        ),
      );

      // 3️⃣ Nếu xác minh thành công → reload danh sách
      if (result == true) {
        await _fetchEmployees();
        _showSuccessSnackBar('✅ Xoá nhân viên "${employee.name}" thành công.');
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi khi xoá nhân viên: $e');
    }
  }

  List<Employee> get filteredEmployees {
    var filtered = employees;

    if (selectedDepartment != 'Tất cả') {
      filtered = filtered
          .where((e) => e.department == selectedDepartment)
          .toList();
    }

    if (searchController.text.isNotEmpty) {
      final searchTerm = searchController.text.toLowerCase();
      filtered = filtered.where((e) =>
      e.name.toLowerCase().contains(searchTerm) ||
          e.email.toLowerCase().contains(searchTerm) ||
          e.phone.contains(searchTerm)).toList();
    }

    return filtered;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ✅ Cập nhật hộp thoại xác nhận
  void _showDeleteConfirmDialog(Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa nhân viên "${employee.name}" không?\n'
            'Hệ thống sẽ gửi mã OTP đến số điện thoại admin để xác minh.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEmployeeWithOtp(employee); // ✅ Gọi flow mới
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToForm({Employee? employee}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeFormPage(employee: employee),
      ),
    );

    if (result == true) {
      _fetchEmployees();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý nhân viên'),
        backgroundColor: const Color(0xFF0066FF),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchEmployees,
            tooltip: 'Làm mới',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(child: _buildEmployeeList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(),
        icon: const Icon(Icons.add),
        label: const Text('Thêm nhân viên'),
        backgroundColor: const Color(0xFF0066FF),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm theo tên, email hoặc SĐT',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  setState(() {});
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                'Tất cả',
                'Hành chính',
                'Nhân sự',
                'Kỹ thuật',
                'Kinh doanh',
                'Marketing',
                'Tài chính'
              ].map((dept) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(dept),
                    selected: selectedDepartment == dept,
                    onSelected: (selected) {
                      setState(() => selectedDepartment = dept);
                    },
                    selectedColor: const Color(0xFF0066FF).withOpacity(0.2),
                    checkmarkColor: const Color(0xFF0066FF),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredEmployees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              searchController.text.isNotEmpty
                  ? 'Không tìm thấy nhân viên'
                  : 'Chưa có nhân viên nào',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchEmployees,
      child: ListView.builder(
        itemCount: filteredEmployees.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final employee = filteredEmployees[index];
          return _buildEmployeeCard(employee);
        },
      ),
    );
  }

  Widget _buildEmployeeCard(Employee employee) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToForm(employee: employee),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF0066FF),
                child: Text(
                  employee.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.email, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            employee.email,
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          employee.phone,
                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildBadge(employee.position, Colors.blue),
                        const SizedBox(width: 8),
                        _buildBadge(employee.department, Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Sửa'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Xóa'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    _navigateToForm(employee: employee);
                  } else if (value == 'delete') {
                    _showDeleteConfirmDialog(employee);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
