import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';

class EmployeeFormPage extends StatefulWidget {
  final Employee? employee;

  const EmployeeFormPage({Key? key, this.employee}) : super(key: key);

  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final EmployeeService _employeeService = EmployeeService();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  String selectedPosition = 'Nhân viên';
  String selectedDepartment = 'Kỹ thuật';
  bool isLoading = false;

  final List<String> positions = [
    'Giám đốc',
    'Phó giám đốc',
    'Trưởng phòng',
    'Nhân viên',
    'Thực tập sinh'
  ];

  final List<String> departments = [
    'Hành chính',
    'Nhân sự',
    'Kỹ thuật',
    'Kinh doanh',
    'Marketing',
    'Tài chính'
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.employee?.name ?? '');
    emailController = TextEditingController(text: widget.employee?.email ?? '');
    phoneController = TextEditingController(text: widget.employee?.phone ?? '');

    if (widget.employee != null) {
      selectedPosition = widget.employee!.position;
      selectedDepartment = widget.employee!.department;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  bool get isEditMode => widget.employee != null;

  Future<void> _saveEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final employee = Employee(
        id: widget.employee?.id ?? '',
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        position: selectedPosition,
        department: selectedDepartment,
      );

      if (isEditMode) {
        await _employeeService.updateEmployee(widget.employee!.id, employee);
      } else {
        await _employeeService.createEmployee(employee);
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditMode
                  ? 'Cập nhật nhân viên thành công'
                  : 'Thêm nhân viên thành công',
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Sửa nhân viên' : 'Thêm nhân viên'),
        backgroundColor: const Color(0xFF0066FF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 24),
              _buildNameField(),
              const SizedBox(height: 16),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPhoneField(),
              const SizedBox(height: 16),
              _buildPositionDropdown(),
              const SizedBox(height: 16),
              _buildDepartmentDropdown(),
              const SizedBox(height: 24),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isEditMode ? Icons.edit : Icons.person_add,
            size: 40,
            color: Colors.blue.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditMode ? 'Cập nhật thông tin' : 'Thông tin nhân viên',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                Text(
                  'Vui lòng điền đầy đủ thông tin bên dưới',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: 'Tên nhân viên *',
        hintText: 'Nhập họ tên đầy đủ',
        prefixIcon: const Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vui lòng nhập tên nhân viên';
        }
        if (value.trim().length < 2) {
          return 'Tên phải có ít nhất 2 ký tự';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: 'Email *',
        hintText: 'example@email.com',
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vui lòng nhập email';
        }
        // SỬA LỖI REGEX Ở ĐÂY
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Email không hợp lệ';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: phoneController,
      decoration: InputDecoration(
        labelText: 'Số điện thoại *',
        hintText: '0123456789',
        prefixIcon: const Icon(Icons.phone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: TextInputType.phone,
      maxLength: 10,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Vui lòng nhập số điện thoại';
        }
        if (value.trim().length != 10) {
          return 'Số điện thoại phải có 10 chữ số';
        }
        // SỬA LỖI REGEX Ở ĐÂY
        if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
          return 'Số điện thoại chỉ chứa chữ số';
        }
        return null;
      },
    );
  }

  Widget _buildPositionDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedPosition,
      decoration: InputDecoration(
        labelText: 'Chức vụ *',
        prefixIcon: const Icon(Icons.work),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: positions.map((position) {
        return DropdownMenuItem(
          value: position,
          child: Text(position),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => selectedPosition = value!);
      },
    );
  }

  Widget _buildDepartmentDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedDepartment,
      decoration: InputDecoration(
        labelText: 'Phòng ban *',
        prefixIcon: const Icon(Icons.business),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: departments.map((dept) {
        return DropdownMenuItem(
          value: dept,
          child: Text(dept),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => selectedDepartment = value!);
      },
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : _saveEmployee,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0066FF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: isLoading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : Text(
        isEditMode ? 'CẬP NHẬT' : 'THÊM NHÂN VIÊN',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}