import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpVerificationPage extends StatefulWidget {
  final int employeeId;
  const OtpVerificationPage({super.key, required this.employeeId});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  Future<void> verifyOtp() async {
    setState(() => isLoading = true);
    final baseUrl = 'http://10.0.2.2:3000/api/otp';
    final token = '<JWT_TOKEN_ADMIN>'; // gán token thật khi bạn login nhé

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-delete/${widget.employeeId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'code': otpController.text.trim()}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['ok'] == true) {
        // ✅ Thành công → quay lại trang nhân viên
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Xác minh thành công, nhân viên đã bị xóa.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ ${data["message"] ?? "Mã OTP không hợp lệ"}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text(
          'Xác minh OTP',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 70, color: Color(0xFF1565C0)),
            const SizedBox(height: 20),
            const Text(
              'Vui lòng nhập mã OTP được gửi tới số điện thoại của admin để xác nhận xóa nhân viên.',
              style: TextStyle(fontSize: 16, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Ô nhập OTP
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: 'Nhập mã OTP gồm 6 chữ số',
                counterText: '',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
              ),
              style: const TextStyle(
                letterSpacing: 4,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // Nút xác nhận
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text(
                  'XÁC NHẬN',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: verifyOtp,
              ),
            ),

            const SizedBox(height: 20),

            // Nút quay lại
            TextButton.icon(
              onPressed: () => Navigator.pop(context, false),
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              label: const Text(
                'Quay lại trang nhân viên',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
