import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:3000/api';
}
