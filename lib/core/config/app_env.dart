import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://127.0.0.1:3000/api';
}
