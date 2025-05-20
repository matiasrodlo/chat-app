import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/User.dart';
import '../classes/Specialist.dart';
import '../classes/Chat.dart';
import '../classes/ChatMessage.dart';

class LocalService {
  static final LocalService _instance = LocalService._internal();
  factory LocalService() => _instance;
  LocalService._internal();

  SharedPreferences? _prefs;
  static const String _userKey = 'user_data';
  static const String _messagesKey = 'chat_messages';
  static const String _chatsKey = 'chats';
  static const String _usersKey = 'users';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Initialize with empty users list if not exists
    if (!_prefs!.containsKey(_usersKey)) {
      await _prefs!.setString(_usersKey, '[]');
    }
  }

  Future<void> _ensurePrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  Future<User?> getUser() async {
    await _ensurePrefs();
    final userJson = _prefs!.getString(_userKey);
    if (userJson == null) return null;
    return User.fromMap(json.decode(userJson));
  }

  Future<List<Chat>> getChats() async {
    await _ensurePrefs();
    final chatsJson = _prefs!.getString(_chatsKey) ?? '[]';
    final chats = List<Map<String, dynamic>>.from(json.decode(chatsJson));
    return chats.map((c) => Chat.fromMap(c)).toList();
  }

  Future<List<ChatMessage>> getMessages() async {
    await _ensurePrefs();
    final messagesJson = _prefs!.getString(_messagesKey) ?? '[]';
    final List<dynamic> messagesList = json.decode(messagesJson);
    return messagesList.map((m) => ChatMessage.fromJson(m)).toList();
  }

  Future<void> saveMessage(ChatMessage message) async {
    await _ensurePrefs();
    final messages = await getMessages();
    messages.add(message);
    await _prefs!.setString(_messagesKey, json.encode(messages.map((m) => m.toJson()).toList()));
  }

  Future<void> closeSession() async {
    await _ensurePrefs();
    await _prefs!.remove(_userKey);
  }

  Stream<ChatMessage> get messageStream async* {
    // This is a mock stream for demonstration purposes
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      final testMessage = ChatMessage(
        id: '1',
        senderId: '1',
        content: 'Test message',
        timestamp: DateTime.now(),
      );
      yield testMessage;
    }
  }

  Future<void> clearMessages() async {
    await _ensurePrefs();
    await _prefs!.remove(_messagesKey);
  }
} 