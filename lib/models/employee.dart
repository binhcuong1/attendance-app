class Employee {
  final int maNhanVien;
  final String tenNhanVien;
  final String email;
  final String sdt;
  final int maChucVu;
  final int maPhongBan;
  final String tenChucVu;
  final String tenPhongBan;

  Employee({
    required this.maNhanVien,
    required this.tenNhanVien,
    required this.email,
    required this.sdt,
    required this.maChucVu,
    required this.maPhongBan,
    required this.tenChucVu,
    required this.tenPhongBan,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      maNhanVien: json['ma_nhan_vien'],
      tenNhanVien: json['ten_nhan_vien'],
      email: json['email'],
      sdt: json['sdt'] ?? '',
      maChucVu: json['ma_chuc_vu'],
      maPhongBan: json['ma_phong_ban'],
      tenChucVu: json['ten_chuc_vu'] ?? '',
      tenPhongBan: json['ten_phong_ban'] ?? '',
    );
  }
}
