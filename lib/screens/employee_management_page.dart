import 'package:flutter/material.dart';
import '../services-dat/employee_service.dart';
import '../models/employee.dart';
import 'employee_form_page.dart';

class EmployeeManagementPage extends StatefulWidget {
  const EmployeeManagementPage({super.key});

  @override
  State<EmployeeManagementPage> createState() => _EmployeeManagementPageState();
}

class _EmployeeManagementPageState extends State<EmployeeManagementPage> {
  final _service = EmployeeService();
  List<Employee> employees = [];
  List<Employee> filteredEmployees = [];
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    try {
      final data = await _service.getEmployees();
      setState(() {
        employees = data.map<Employee>((e) => Employee.fromJson(e)).toList();
        filteredEmployees = employees;
      });
    } catch (e) {
      debugPrint('⌛ Lỗi load nhân viên: $e');
    }
  }

  void _searchEmployee(String keyword) {
    keyword = keyword.toLowerCase();
    setState(() {
      if (keyword.isEmpty) {
        filteredEmployees = employees;
      } else {
        filteredEmployees = employees
            .where((emp) => emp.tenNhanVien.toLowerCase().contains(keyword))
            .toList();
      }
    });
  }

  void _openForm([Employee? emp]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmployeeFormPage(
          employee: emp != null
              ? {
            'ma_nhan_vien': emp.maNhanVien,
            'ten_nhan_vien': emp.tenNhanVien,
            'email': emp.email,
            'sdt': emp.sdt,
            'ma_chuc_vu': emp.maChucVu,      // ✅ dùng ID
            'ma_phong_ban': emp.maPhongBan,  // ✅ dùng ID
          }
              : null,
        ),
      ),
    );

    if (result == true) _loadEmployees(); // ✅ giữ nguyên
  }


  // ✅ THÊM CHỨC NĂNG XÓA
  Future<void> _deleteEmployee(Employee emp) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận'),
        content: Text('Bạn có chắc muốn xóa nhân viên "${emp.tenNhanVien}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _service.deleteEmployee(emp.maNhanVien);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xóa nhân viên thành công')),
        );
        _loadEmployees();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý nhân viên')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // ======= THANH TÌM KIẾM =======
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm nhân viên theo tên...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchCtrl.clear();
                    _searchEmployee('');
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _searchEmployee,
            ),
            const SizedBox(height: 12),

            // ======= DANH SÁCH NHÂN VIÊN =======
            Expanded(
              child: filteredEmployees.isEmpty
                  ? const Center(child: Text('Không có nhân viên nào'))
                  : RefreshIndicator(
                onRefresh: _loadEmployees,
                child: ListView.builder(
                  itemCount: filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final e = filteredEmployees[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(e.tenNhanVien,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          '${e.tenPhongBan ?? "Không có phòng ban"}\n${e.tenChucVu ?? "Không có chức vụ"}',
                          style: const TextStyle(height: 1.4),
                        ),
                        // ✅ THÊM NÚT XÓA
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _openForm(e),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteEmployee(e),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text('Thêm nhân viên'),
      ),
    );
  }
}