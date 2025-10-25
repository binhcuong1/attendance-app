class NhanVien {
  final int maNhanVien;
  final String tenNhanVien;
  final String email;
  final String sdt;
  final String tenChucVu;
  final String tenPhongBan;

  // 🆕 Thêm 2 trường để lưu id chức vụ và phòng ban
  final int? maChucVu;
  final int? maPhongBan;

  NhanVien({
    required this.maNhanVien,
    required this.tenNhanVien,
    required this.email,
    required this.sdt,
    required this.tenChucVu,
    required this.tenPhongBan,
    this.maChucVu,
    this.maPhongBan,
  });

  // 🧩 Tạo đối tượng từ JSON
  factory NhanVien.fromJson(Map<String, dynamic> json) {
    return NhanVien(
      maNhanVien: json['ma_nhan_vien'] ?? 0,
      tenNhanVien: json['ten_nhan_vien'] ?? '',
      email: json['email'] ?? '',
      sdt: json['sdt'] ?? '',
      tenChucVu: json['ten_chuc_vu'] ?? '',
      tenPhongBan: json['ten_phong_ban'] ?? '',
      maChucVu: json['ma_chuc_vu'],
      maPhongBan: json['ma_phong_ban'],
    );
  }

  // 🧾 Convert đối tượng ra JSON để gửi lên server
  Map<String, dynamic> toJson() {
    return {
      'ma_nhan_vien': maNhanVien,
      'ten_nhan_vien': tenNhanVien,
      'email': email,
      'sdt': sdt,
      'ten_chuc_vu': tenChucVu,
      'ten_phong_ban': tenPhongBan,
      'ma_chuc_vu': maChucVu,
      'ma_phong_ban': maPhongBan,
    };
  }

  // ⚙️ Hàm hỗ trợ copy nhanh (ít khi dùng nhưng hữu ích)
  NhanVien copyWith({
    int? maNhanVien,
    String? tenNhanVien,
    String? email,
    String? sdt,
    String? tenChucVu,
    String? tenPhongBan,
    int? maChucVu,
    int? maPhongBan,
  }) {
    return NhanVien(
      maNhanVien: maNhanVien ?? this.maNhanVien,
      tenNhanVien: tenNhanVien ?? this.tenNhanVien,
      email: email ?? this.email,
      sdt: sdt ?? this.sdt,
      tenChucVu: tenChucVu ?? this.tenChucVu,
      tenPhongBan: tenPhongBan ?? this.tenPhongBan,
      maChucVu: maChucVu ?? this.maChucVu,
      maPhongBan: maPhongBan ?? this.maPhongBan,
    );
  }
}
