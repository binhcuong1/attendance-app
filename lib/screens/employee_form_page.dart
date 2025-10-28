import 'package:flutter/material.dart';
import '../data/services/employee_service.dart';

class EmployeeFormPage extends StatefulWidget {
  final Map<String, dynamic>? employee;
  const EmployeeFormPage({super.key, this.employee});

  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = EmployeeService();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  List<dynamic> chucVuList = [];
  List<dynamic> phongBanList = [];
  dynamic selectedChucVu;
  dynamic selectedPhongBan;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    chucVuList = await _service.getChucVu();
    phongBanList = await _service.getPhongBan();
    setState(() {});
  }

  // ================== CRUD CHỨC VỤ ==================
  Future<void> _manageChucVu() async {
    TextEditingController tenCtrl = TextEditingController();
    TextEditingController heSoCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quản lý Chức vụ'),
        content: SizedBox(
          height: 350, // 👈 cố định chiều cao tránh lỗi layout
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: chucVuList.length,
                    itemBuilder: (_, i) {
                      final cv = chucVuList[i];
                      return ListTile(
                        title: Text(cv['ten_chuc_vu']),
                        subtitle: Text('Hệ số: ${cv['he_so_luong']}'),
                        trailing: Wrap(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () async {
                                tenCtrl.text = cv['ten_chuc_vu'];
                                heSoCtrl.text = cv['he_so_luong'].toString();

                                await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Sửa chức vụ'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: tenCtrl,
                                          decoration: const InputDecoration(
                                            labelText: 'Tên chức vụ',
                                          ),
                                        ),
                                        TextField(
                                          controller: heSoCtrl,
                                          keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                          decoration: const InputDecoration(
                                            labelText: 'Hệ số lương',
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text('Hủy'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await _service.updateChucVu(
                                            cv['ma_chuc_vu'],
                                            tenCtrl.text,
                                            double.tryParse(heSoCtrl.text) ?? 1,
                                          );
                                          Navigator.pop(context);
                                          await _loadData();
                                        },
                                        child: const Text('Lưu'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon:
                              const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Xác nhận'),
                                    content: Text(
                                        'Bạn có chắc muốn xóa chức vụ "${cv['ten_chuc_vu']}"?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Hủy')),
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Xóa')),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await _service.deleteChucVu(cv['ma_chuc_vu']);
                                  await _loadData();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Thêm mới'),
                onPressed: () async {
                  tenCtrl.clear();
                  heSoCtrl.clear();

                  await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Thêm chức vụ mới'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: tenCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Tên chức vụ',
                            ),
                          ),
                          TextField(
                            controller: heSoCtrl,
                            keyboardType:
                            const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Hệ số lương',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Hủy'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _service.addChucVu(
                              tenCtrl.text,
                              double.tryParse(heSoCtrl.text) ?? 1,
                            );
                            Navigator.pop(context);
                            await _loadData();
                          },
                          child: const Text('Lưu'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================== CRUD PHÒNG BAN ==================
  Future<void> _managePhongBan() async {
    TextEditingController tenCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quản lý Phòng ban'),
        content: SizedBox(
          height: 350, // 👈 tránh lỗi RenderBox
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: phongBanList.length,
                    itemBuilder: (_, i) {
                      final pb = phongBanList[i];
                      return ListTile(
                        title: Text(pb['ten_phong_ban']),
                        trailing: Wrap(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.orangeAccent),
                              onPressed: () async {
                                tenCtrl.text = pb['ten_phong_ban'];
                                await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Sửa phòng ban'),
                                    content: TextField(
                                      controller: tenCtrl,
                                      decoration: const InputDecoration(
                                          labelText: 'Tên phòng ban'),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text('Hủy'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await _service.updatePhongBan(
                                              pb['ma_phong_ban'],
                                              tenCtrl.text);
                                          Navigator.pop(context);
                                          await _loadData();
                                        },
                                        child: const Text('Lưu'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon:
                              const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Xác nhận'),
                                    content: Text(
                                        'Bạn có chắc muốn xóa phòng ban "${pb['ten_phong_ban']}"?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Hủy')),
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Xóa')),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await _service
                                      .deletePhongBan(pb['ma_phong_ban']);
                                  await _loadData();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Thêm mới'),
                onPressed: () async {
                  tenCtrl.clear();
                  await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Thêm phòng ban mới'),
                      content: TextField(
                        controller: tenCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Tên phòng ban'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Hủy'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _service.addPhongBan(tenCtrl.text);
                            Navigator.pop(context);
                            await _loadData();
                          },
                          child: const Text('Lưu'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final data = {
      'ten_nhan_vien': nameCtrl.text,
      'email': emailCtrl.text,
      'sdt': phoneCtrl.text,
      'ma_chuc_vu': selectedChucVu,      // ✅ là ID
      'ma_phong_ban': selectedPhongBan,  // ✅ là ID
    };
    await _service.addEmployee(data);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm nhân viên')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên nhân viên')),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Số điện thoại')),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: selectedChucVu,
                    items: chucVuList.map((cv) {
                      return DropdownMenuItem(
                        value: cv['ma_chuc_vu'],
                        child: Text(cv['ten_chuc_vu']),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => selectedChucVu = v),
                    decoration: const InputDecoration(labelText: 'Chức vụ'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.blueAccent),
                  onPressed: _manageChucVu,
                  tooltip: 'Quản lý chức vụ',
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: selectedPhongBan,
                    items: phongBanList.map((pb) {
                      return DropdownMenuItem(
                        value: pb['ma_phong_ban'],
                        child: Text(pb['ten_phong_ban']),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => selectedPhongBan = v),
                    decoration: const InputDecoration(labelText: 'Phòng ban'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.blueAccent),
                  onPressed: _managePhongBan,
                  tooltip: 'Quản lý phòng ban',
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: const Text('Thêm nhân viên')),
          ],
        ),
      ),
    );
  }
}
