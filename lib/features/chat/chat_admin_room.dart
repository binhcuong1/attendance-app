import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Đổi IP/host cho đúng backend bạn
final String baseUrl   = dotenv.env['BASE_URL']!;
final String socketUrl = dotenv.env['SOCKET_URL']!;

class ChatAdminRoom extends StatefulWidget {
  final int conversationId;
  const ChatAdminRoom({super.key, required this.conversationId});

  @override
  State<ChatAdminRoom> createState() => _ChatAdminRoomState();
}

class _ChatAdminRoomState extends State<ChatAdminRoom> {
  late IO.Socket socket;
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<Map<String, dynamic>> messages = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _initSocket();
  }

  Future<void> _loadHistory() async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/chat/${widget.conversationId}/messages'),
      );
      if (res.statusCode == 200) {
        final List list = jsonDecode(res.body);
        messages.clear();
        messages.addAll(list.cast<Map<String, dynamic>>());
      }
    } finally {
      if (mounted) setState(() => loading = false);
      _scrollToEnd();
    }
  }

  void _initSocket() {
    socket = IO.io(socketUrl, {
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    socket.onConnect((_) {
      socket.emit('join', widget.conversationId.toString());
    });

    socket.on('receive_message', (data) {
      setState(() => messages.add(Map<String, dynamic>.from(data)));
      _scrollToEnd();
    });
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    final msg = {
      'conversation_id': widget.conversationId,
      'sender': 'admin',
      'text': text,
    };
    socket.emit('send_message', msg);
    setState(() => messages.add(msg));
    _ctrl.clear();
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    socket.dispose();
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cid = widget.conversationId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation #$cid (Admin)'),
      ),
      body: Column(
        children: [
          if (loading) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final m = messages[i];
                final isAdmin = (m['sender'] == 'admin');
                return Align(
                  alignment:
                  isAdmin ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isAdmin ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(m['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextField(
                      controller: _ctrl,
                      decoration: const InputDecoration(
                        hintText: 'Nhập trả lời...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _send),
                const SizedBox(width: 6),
              ],
            ),
          )
        ],
      ),
    );
  }
}
