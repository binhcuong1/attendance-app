import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ bắt buộc có

import 'providers/payroll_provider.dart';
import 'features/payroll/payroll_summary_page.dart';
import 'features/auth/login_page.dart';

Future<void> main() async {
  // ✅ Bắt buộc để khởi tạo plugin trước khi runApp
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Load file .env (BASE_URL, v.v.)
  await dotenv.load(fileName: ".env");

  // ✅ Khởi tạo SharedPreferences (fix lỗi channel-error)
  try {
    await SharedPreferences.getInstance();
    debugPrint('📦 SharedPreferences initialized successfully');
  } catch (e) {
    debugPrint('⚠️ SharedPreferences init failed: $e');
  }

  // ✅ Khởi tạo định dạng ngày (ngôn ngữ Việt Nam)
  await initializeDateFormatting('vi_VN', null);

  // ✅ Chạy ứng dụng
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PayrollProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),

      // ✅ Cấu hình ngôn ngữ
      locale: const Locale('vi', 'VN'),
      supportedLocales: const [
        Locale('vi', 'VN'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ✅ Màn hình khởi đầu
      home: const LoginPage(),

      // ✅ Đăng ký các route khác
      routes: {
        '/payroll-summary': (_) => const PayrollSummaryPage(),
      },
    );
  }
}
