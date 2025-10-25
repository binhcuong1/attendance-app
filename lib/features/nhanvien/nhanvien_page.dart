import 'package:flutter/material.dart';
import '../../data/models/nhanvien_model.dart';
import '../../data/services/nhanvien_service.dart';
import '../../data/services/dropdown_service.dart';

class NhanVienPage extends StatefulWidget {
  const NhanVienPage({super.key});

  @override
  State<NhanVienPage> createState() => _NhanVienPageState();
}

class _NhanVienPageState extends State<NhanVienPage> {
  final NhanVienService _service = NhanVienService();
  List<NhanVien> nhanviens = [];
  List<Map<String, dynamic>> chucVus = [];
  List<Map<String, dynamic>> phongBans = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  Future<void> loadAllData() async {
    try {
      final nvData = await _service.getAll();
      final cvData = await DropdownService.getChucVu();
      final pbData = await DropdownService.getPhongBan();

      setState(() {
        nhanviens = nvData;
        chucVus = cvData;
        phongBans = pbData;
        loading = false;
      });
    } catch (e) {
      print("❌ Lỗi tải dữ liệu: $e");
    }
  }

  Future<void> _showNhanVienDialog({NhanVien? nv}) async {
    final nameController = TextEditingController(text: nv?.tenNhanVien ?? '');
    final emailController = TextEditingController(text: nv?.email ?? '');
    final sdtController = TextEditingController(text: nv?.sdt ?? '');
    final isEdit = nv != null;

    print("----------------------------------------------------");
    print("🟢 Đang mở dialog ${isEdit ? 'SỬA' : 'THÊM'} nhân viên");

    if (nv != null) {
      print("👤 Nhân viên hiện tại: ${nv.tenNhanVien}");
      print("📧 Email: ${nv.email}");
      print("📞 SĐT: ${nv.sdt}");
      print("💼 Chức vụ hiện tại: ${nv.tenChucVu}");
      print("🏢 Phòng ban hiện tại: ${nv.tenPhongBan}");
    }

    // 🔹 Map chức vụ / phòng ban sang id
    int selectedChucVu = nv != null
        ? chucVus.firstWhere(
            (cv) =>
        cv['ten'].toString().trim().toLowerCase() ==
            nv.tenChucVu.toString().trim().toLowerCase(),
        orElse: () => chucVus.first)['id']
        : chucVus.first['id'];

    int selectedPhongBan = nv != null
        ? phongBans.firstWhere(
            (pb) =>
        pb['ten'].toString().trim().toLowerCase() ==
            nv.tenPhongBan.toString().trim().toLowerCase(),
        orElse: () => phongBans.first)['id']
        : phongBans.first['id'];

    print("✅ Mapped selectedChucVu: $selectedChucVu");
    print("✅ Mapped selectedPhongBan: $selectedPhongBan");

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(isEdit ? "✏️ Sửa nhân viên" : "➕ Thêm nhân viên"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Tên nhân viên'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: sdtController,
                      decoration: const InputDecoration(labelText: 'Số điện thoại'),
                    ),
                    const SizedBox(height: 10),

                    // 🔹 Dropdown chọn chức vụ
                    DropdownButtonFormField<int>(
                      value: selectedChucVu,
                      items: chucVus.map((e) {
                        print("🔹 Dropdown Chức vụ item: ${e['id']} - ${e['ten']}");
                        return DropdownMenuItem<int>(
                          value: e['id'],
                          child: Text(e['ten']),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() {
                          selectedChucVu = val!;
                          print("🌀 Đổi chức vụ thành ID: $val");
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Chức vụ'),
                    ),

                    // 🔹 Dropdown chọn phòng ban
                    DropdownButtonFormField<int>(
                      value: selectedPhongBan,
                      items: phongBans.map((e) {
                        print("🔹 Dropdown Phòng ban item: ${e['id']} - ${e['ten']}");
                        return DropdownMenuItem<int>(
                          value: e['id'],
                          child: Text(e['ten']),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() {
                          selectedPhongBan = val!;
                          print("🌀 Đổi phòng ban thành ID: $val");
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Phòng ban'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Hủy"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    print("💾 Đang lưu nhân viên...");
                    print("✅ Đang lưu với selectedChucVu: $selectedChucVu");
                    print("✅ Đang lưu với selectedPhongBan: $selectedPhongBan");

                    // 🔹 Tạo model đúng chuẩn
                    final nhanvien = NhanVien(
                      maNhanVien: nv?.maNhanVien ?? 0,
                      tenNhanVien: nameController.text.trim(),
                      email: emailController.text.trim(),
                      sdt: sdtController.text.trim(),
                      tenChucVu: chucVus
                          .firstWhere((cv) => cv['id'] == selectedChucVu)['ten'],
                      tenPhongBan: phongBans
                          .firstWhere((pb) => pb['id'] == selectedPhongBan)['ten'],
                      maChucVu: selectedChucVu,
                      maPhongBan: selectedPhongBan,
                    );

                    print("📤 Dữ liệu gửi lên sau fix: ${nhanvien.toJson()}");

                    if (isEdit) {
                      await _service.update(nv!.maNhanVien, nhanvien);
                    } else {
                      await _service.add(nhanvien);
                    }

                    if (context.mounted) Navigator.pop(context);
                    await loadAllData();
                  },
                  child: Text(isEdit ? "Lưu" : "Thêm"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteNhanVien(int id) async {
    try {
      await _service.delete(id);
      await loadAllData();
    } catch (e) {
      print("❌ Lỗi xóa nhân viên: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("👨‍💼 Danh sách nhân viên")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNhanVienDialog(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: nhanviens.length,
        itemBuilder: (context, i) {
          final nv = nhanviens[i];
          return ListTile(
            title: Text(nv.tenNhanVien),
            subtitle: Text(
              "${nv.email} • ${nv.sdt}\n${nv.tenChucVu} - ${nv.tenPhongBan}",
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showNhanVienDialog(nv: nv),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteNhanVien(nv.maNhanVien),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
