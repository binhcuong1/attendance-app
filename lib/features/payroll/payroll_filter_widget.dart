import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../core/config/app_env.dart';

class PayrollFilterWidget extends StatelessWidget {
  final int thang;
  final int nam;
  final void Function(int, int) onChanged;
  final VoidCallback onCalc;
  final VoidCallback onLock;

  const PayrollFilterWidget({
    super.key,
    required this.thang,
    required this.nam,
    required this.onChanged,
    required this.onCalc,
    required this.onLock,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          DropdownButton<int>(
            value: thang,
            items: List.generate(12, (i) => i + 1)
                .map((t) => DropdownMenuItem(value: t, child: Text('Tháng $t')))
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v, nam);
            },
          ),
          const SizedBox(width: 12),
          DropdownButton<int>(
            value: nam,
            items: [2024, 2025, 2026]
                .map((y) => DropdownMenuItem(value: y, child: Text('Năm $y')))
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(thang, v);
            },
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.calculate),
            label: const Text('Tính lương'),
            onPressed: onCalc,
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.lock_outline),
            label: const Text('Chốt lương'),
            onPressed: onLock,
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.download),
            label: const Text('Xuất file'),
            onPressed: () async {
              final url =
                  '${AppEnv.baseUrl}/bangluong/export?thang=$thang&nam=$nam';
              final uri = Uri.parse(url);

              try {
                await launchUrl(uri, mode: LaunchMode.platformDefault);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Không thể mở link tải: $e')),
                );
              }
            },
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.email_outlined),
            label: const Text('Gửi email'),
            onPressed: () async {
              final res = await http.post(
                Uri.parse('${AppEnv.baseUrl}/bangluong/sendmail'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({'thang': thang, 'nam': nam}),
              );
              if (res.statusCode == 200) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã gửi email cho nhân viên!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gửi email thất bại!')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
