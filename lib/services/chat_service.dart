import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/ChatMessage.dart';
import '../classes/Specialist.dart';
import 'local_service.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final LocalService _localService = LocalService();
  final _messageController = StreamController<ChatMessage>.broadcast();
  static const String _messagesKey = 'shared_chat_messages';

  Stream<ChatMessage> get messageStream => _messageController.stream;

  Future<List<ChatMessage>> getMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getStringList(_messagesKey) ?? [];
    
    return messagesJson
        .map((json) => ChatMessage.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> sendMessage(String senderId, String content) async {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      content: content,
      timestamp: DateTime.now(),
    );

    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getStringList(_messagesKey) ?? [];
    messagesJson.add(jsonEncode(message.toJson()));
    await prefs.setStringList(_messagesKey, messagesJson);

    _messageController.add(message);
  }

  Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_messagesKey);
  }

  Future<void> markMessageAsRead(String messageId) async {
    // Implementation for marking messages as read
  }

  void dispose() {
    _messageController.close();
  }
} 