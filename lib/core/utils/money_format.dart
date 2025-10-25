import 'package:intl/intl.dart';

class MoneyFormat {
  static String vnd(num? value) {
    if (value == null) return '0 ₫';
    final f = NumberFormat('#,##0', 'vi_VN');
    return '${f.format(value)} ₫';
  }
}
