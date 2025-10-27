class ThuongPhat {
  final int? maThuongPhat;
  final int? maNhanVien;
  final String? tenNhanVien;
  final String? loaiTP;
  final double? soTien;
  final String? lyDo;
  final DateTime? ngay;

  ThuongPhat({
    this.maThuongPhat,
    this.maNhanVien,
    this.tenNhanVien,
    this.loaiTP,
    this.soTien,
    this.lyDo,
    this.ngay,
  });

  factory ThuongPhat.fromJson(Map<String, dynamic> json) {
    return ThuongPhat(
      maThuongPhat: json['ma_thuong_phat'],
      maNhanVien: json['ma_nhan_vien'],
      tenNhanVien: json['ten_nhan_vien'],
      loaiTP: json['loai_tp'],
      soTien: (json['so_tien'] as num?)?.toDouble(),
      lyDo: json['ly_do'],
      ngay: json['ngay'] != null ? DateTime.parse(json['ngay']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ma_thuong_phat': maThuongPhat,
      'ma_nhan_vien': maNhanVien,
      'loai_tp': loaiTP,
      'so_tien': soTien,
      'ly_do': lyDo,
      'ngay': ngay?.toIso8601String(),
    };
  }
}
