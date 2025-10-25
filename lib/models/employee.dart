class Employee {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String position;
  final String department;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.position,
    required this.department,
  });

  // Mapping position từ tiếng Việt sang mã chức vụ (INTEGER)
  static int _getPositionCode(String position) {
    const positionMap = {
      'Giám đốc': 1,
      'Phó giám đốc': 2,
      'Trưởng phòng': 3,
      'Nhân viên': 4,
      'Thực tập sinh': 5,
    };
    return positionMap[position] ?? 4;
  }

  // Mapping department từ tiếng Việt sang mã phòng ban (INTEGER)
  static int _getDepartmentCode(String department) {
    const departmentMap = {
      'Hành chính': 1,
      'Nhân sự': 2,
      'Kỹ thuật': 3,
      'Kinh doanh': 4,
      'Marketing': 5,
      'Tài chính': 6,
    };
    return departmentMap[department] ?? 3;
  }

  // Mapping từ mã sang tên hiển thị
  static String _getPositionName(dynamic code) {
    // Chuyển về int nếu là string
    int? intCode = code is int ? code : int.tryParse(code?.toString() ?? '');

    const positionMap = {
      1: 'Giám đốc',
      2: 'Phó giám đốc',
      3: 'Trưởng phòng',
      4: 'Nhân viên',
      5: 'Thực tập sinh',
    };
    return positionMap[intCode] ?? 'Nhân viên';
  }

  static String _getDepartmentName(dynamic code) {
    // Chuyển về int nếu là string
    int? intCode = code is int ? code : int.tryParse(code?.toString() ?? '');

    const departmentMap = {
      1: 'Hành chính',
      2: 'Nhân sự',
      3: 'Kỹ thuật',
      4: 'Kinh doanh',
      5: 'Marketing',
      6: 'Tài chính',
    };
    return departmentMap[intCode] ?? 'Kỹ thuật';
  }

  // Parse từ JSON API (format backend)
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['ma_nhan_vien']?.toString() ?? '',
      name: json['ten_nhan_vien'] ?? '',
      email: json['email'] ?? '',
      phone: json['sdt'] ?? '',
      position: _getPositionName(json['ma_chuc_vu']),
      department: _getDepartmentName(json['ma_phong_ban']),
    );
  }

  // Chuyển sang JSON để gửi lên API (format backend)
  Map<String, dynamic> toJson() {
    return {
      'ma_chuc_vu': _getPositionCode(position),
      'ma_phong_ban': _getDepartmentCode(department),
      'ten_nhan_vien': name,
      'email': email,
      'sdt': phone,
    };
  }
}

// Model cho Chức vụ
class ChucVu {
  final String maChucVu;
  final String tenChucVu;

  ChucVu({
    required this.maChucVu,
    required this.tenChucVu,
  });

  factory ChucVu.fromJson(Map<String, dynamic> json) {
    return ChucVu(
      maChucVu: json['ma_chuc_vu'] ?? '',
      tenChucVu: json['ten_chuc_vu'] ?? '',
    );
  }
}

// Model cho Phòng ban
class PhongBan {
  final String maPhongBan;
  final String tenPhongBan;

  PhongBan({
    required this.maPhongBan,
    required this.tenPhongBan,
  });

  factory PhongBan.fromJson(Map<String, dynamic> json) {
    return PhongBan(
      maPhongBan: json['ma_phong_ban'] ?? '',
      tenPhongBan: json['ten_phong_ban'] ?? '',
    );
  }
}