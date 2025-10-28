import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../features/chat/chat_admin_room.dart';

final String baseUrl   = dotenv.env['BASE_URL']!;

class ChatAdminListPage extends StatefulWidget {
  const ChatAdminListPage({super.key});

  @override
  State<ChatAdminListPage> createState() => _ChatAdminListPageState();
}

class _ChatAdminListPageState extends State<ChatAdminListPage> {
  List conversations = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/chat'));
      if (res.statusCode == 200) {
        conversations = jsonDecode(res.body);
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _closeConversation(int id) async {
    await http.patch(
      Uri.parse('$baseUrl/chat/$id/close'),
      headers: {"Content-Type":"application/json"},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat (Admin)'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : conversations.isEmpty
          ? const Center(child: Text('Chưa có cuộc trò chuyện'))
          : ListView.separated(
        itemCount: conversations.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final c = conversations[i];
          return Dismissible(
            key: ValueKey(c['id']),
            direction: DismissDirection.endToStart, // vuốt từ phải qua trái
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.close, color: Colors.white, size: 28),
            ),

            confirmDismiss: (_) async {
              return await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Đóng đoạn chat #${c['id']}?"),
                  actions: [
                    TextButton(onPressed: ()=>Navigator.pop(context,false), child: Text("Huỷ")),
                    TextButton(onPressed: ()=>Navigator.pop(context,true), child: Text("Đóng")),
                  ],
                ),
              );
            },

            onDismissed: (_) async {
              await _closeConversation(c['id']);         // gọi API close
              setState(()=> conversations.removeAt(i));  // gỡ khỏi UI
            },

            child: ListTile(
              leading: const Icon(Icons.forum),
              title: Text('Conversation #${c['id']}'),
              subtitle: Text('user_id: ${c['user_id']} • ${c['status']}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatAdminRoom(conversationId: c['id']),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
