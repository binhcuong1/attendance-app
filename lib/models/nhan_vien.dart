class NhanVien {
  final int maNhanVien;
  final int maChucVu;
  final int maPhongBan;
  final String tenNhanVien;
  final String? email;
  final String? sdt;
  final int daXoa;

  NhanVien({
    required this.maNhanVien,
    required this.maChucVu,
    required this.maPhongBan,
    required this.tenNhanVien,
    this.email,
    this.sdt,
    this.daXoa = 0,
  });

  factory NhanVien.fromJson(Map<String, dynamic> json) {
    return NhanVien(
      maNhanVien: json['ma_nhan_vien'],
      maChucVu: json['ma_chuc_vu'],
      maPhongBan: json['ma_phong_ban'],
      tenNhanVien: json['ten_nhan_vien'],
      email: json['email'],
      sdt: json['sdt'],
      daXoa: json['da_xoa'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ma_nhan_vien': maNhanVien,
      'ma_chuc_vu': maChucVu,
      'ma_phong_ban': maPhongBan,
      'ten_nhan_vien': tenNhanVien,
      'email': email,
      'sdt': sdt,
      'da_xoa': daXoa,
    };
  }
}
