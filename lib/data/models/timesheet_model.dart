class Payroll {
  final int maLuong;
  final int maNhanVien;
  final int thang;
  final int nam;
  final double luongCoSo;
  final double tongPhuCap;
  final double tongThuong;
  final double tongPhat;
  final double luongTheoNgayCong;
  final double tienLamThem;
  final String? tenNhanVien;
  final String? tenChucVu;
  final String? tenPhongBan;

  Payroll({
    required this.maLuong,
    required this.maNhanVien,
    required this.thang,
    required this.nam,
    required this.luongCoSo,
    required this.tongPhuCap,
    required this.tongThuong,
    required this.tongPhat,
    required this.luongTheoNgayCong,
    required this.tienLamThem,
    this.tenNhanVien,
    this.tenChucVu,
    this.tenPhongBan,
  });

  factory Payroll.fromJson(Map<String, dynamic> json) => Payroll(
    maLuong: json['ma_luong'],
    maNhanVien: json['ma_nhan_vien'],
    thang: json['thang'],
    nam: json['nam'],
    luongCoSo: double.parse(json['luong_co_so'].toString()),
    tongPhuCap: double.parse(json['tong_phu_cap'].toString()),
    tongThuong: double.parse(json['tong_thuong'].toString()),
    tongPhat: double.parse(json['tong_phat'].toString()),
    luongTheoNgayCong: double.parse(json['luong_theo_ngay_cong'].toString()),
    tienLamThem: double.parse(json['tien_lam_them'].toString()),
    tenNhanVien: json['ten_nhan_vien'],
    tenChucVu: json['ten_chuc_vu'],
    tenPhongBan: json['ten_phong_ban'],
  );
}
