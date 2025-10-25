class CaModel {
  final int maCaLamViec;
  final String tenCa;
  final String gioBatDau;
  final String gioKetThuc;
  final String ngayLamViec;

  CaModel({
    required this.maCaLamViec,
    required this.tenCa,
    required this.gioBatDau,
    required this.gioKetThuc,
    required this.ngayLamViec,
  });

  factory CaModel.fromJson(Map<String, dynamic> json) {
    return CaModel(
      maCaLamViec: json['ma_ca_lam_viec'] ?? 0,
      tenCa: json['ten_ca'] ?? '',
      gioBatDau: json['gio_bat_dau'] ?? '',
      gioKetThuc: json['gio_ket_thuc'] ?? '',
      ngayLamViec: json['ngay_lam_viec'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'tenCa': tenCa,
    'gioBatDau': gioBatDau,
    'gioKetThuc': gioKetThuc,
    'ngayLamViec': ngayLamViec,
  };

}
