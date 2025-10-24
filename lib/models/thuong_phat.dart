class ThuongPhat {
  final int maThuongPhat;
  final int maNhanVien;
  final String loaiTP;
  final double soTien;
  final String ngay;
  final String? lyDo;
  final String? tenNhanVien; // Thêm tên nhân viên

  ThuongPhat({
    required this.maThuongPhat,
    required this.maNhanVien,
    required this.loaiTP,
    required this.soTien,
    required this.ngay,
    this.lyDo,
    this.tenNhanVien,
  });

  factory ThuongPhat.fromJson(Map<String, dynamic> json) {
    return ThuongPhat(
      maThuongPhat: json['ma_thuong_phat'],
      maNhanVien: json['ma_nhan_vien'],
      loaiTP: json['loai_tp'],
      soTien: double.tryParse(json['so_tien'].toString()) ?? 0.0,
      ngay: json['ngay'],
      lyDo: json['ly_do'],
      tenNhanVien: json['nhan_vien']?['ten_nhan_vien'], // lấy từ BE
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ma_nhan_vien': maNhanVien,
      'ngay': ngay,
      'loai_tp': loaiTP,
      'so_tien': soTien,
      'ly_do': lyDo,
    };
  }
}
