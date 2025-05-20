import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/config/app_config.dart';

/// Service for handling local storage operations
class StorageService {
  static final StorageService _instance = StorageService._internal();
  late SharedPreferences _prefs;

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs.setString(AppConfig.userKey, jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final userStr = _prefs.getString(AppConfig.userKey);
    if (userStr == null) return null;
    return jsonDecode(userStr) as Map<String, dynamic>;
  }

  Future<void> saveMessages(List<Map<String, dynamic>> messages) async {
    await _prefs.setString(AppConfig.messagesKey, jsonEncode(messages));
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    final messagesStr = _prefs.getString(AppConfig.messagesKey);
    if (messagesStr == null) return [];
    final List<dynamic> decoded = jsonDecode(messagesStr);
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> saveChats(List<Map<String, dynamic>> chats) async {
    await _prefs.setString(AppConfig.chatsKey, jsonEncode(chats));
  }

  Future<List<Map<String, dynamic>>> getChats() async {
    final chatsStr = _prefs.getString(AppConfig.chatsKey);
    if (chatsStr == null) return [];
    final List<dynamic> decoded = jsonDecode(chatsStr);
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> saveUsers(List<Map<String, dynamic>> users) async {
    await _prefs.setString(AppConfig.usersKey, jsonEncode(users));
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final usersStr = _prefs.getString(AppConfig.usersKey);
    if (usersStr == null) return [];
    final List<dynamic> decoded = jsonDecode(usersStr);
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
} 