import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/User.dart';
import '../classes/Specialist.dart';
import '../classes/Chat.dart';
import '../classes/ChatMessage.dart';
import 'websocket_service.dart';

/// Local service that handles all data operations without external API dependencies
class LocalService {
  static final LocalService _instance = LocalService._internal();
  factory LocalService() => _instance;
  LocalService._internal();

  SharedPreferences? _prefs;
  final WebSocketService _wsService = WebSocketService();
  static const String _userKey = 'user_data';
  static const String _messagesKey = 'chat_messages';
  static const String _chatsKey = 'chats';
  static const String _usersKey = 'users';
  
  /// Initialize the service and load preferences
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

  /// User Authentication Methods
  Future<User> login(String email, String password) async {
    await _ensurePrefs();
    
    // Get stored users
    final usersJson = _prefs!.getString(_usersKey) ?? '[]';
    final users = List<Map<String, dynamic>>.from(json.decode(usersJson));
    
    // Find user
    final userData = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => throw Exception('Invalid credentials'),
    );
    
    final user = User.fromMap(userData);
    
    // Store current user
    await saveUser(user);
    
    // Connect to WebSocket
    await _wsService.connect(user.id!);
    
    return user;
  }

  Future<User> register(Map<String, dynamic> userData) async {
    await _ensurePrefs();
    
    // Get stored users
    final usersJson = _prefs!.getString(_usersKey) ?? '[]';
    final users = List<Map<String, dynamic>>.from(json.decode(usersJson));
    
    // Check if email already exists
    if (users.any((u) => u['email'] == userData['email'])) {
      throw Exception('Email already registered');
    }
    
    // Create new user
    final newUser = {
      ...userData,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'state': 'active',
      'google': false,
      'role': 'user',
    };
    
    // Save user to users list
    users.add(newUser);
    await _prefs!.setString(_usersKey, json.encode(users));
    
    // Create user instance
    final user = User.fromMap(newUser);
    
    // Save as current user
    await saveUser(user);
    
    // Connect to WebSocket
    await _wsService.connect(user.id!);
    
    return user;
  }

  /// Chat Methods
  Future<List<Chat>> getChats() async {
    await _ensurePrefs();
    final chatsJson = _prefs!.getString(_chatsKey) ?? '[]';
    final chats = List<Map<String, dynamic>>.from(json.decode(chatsJson));
    return chats.map((c) => Chat.fromMap(c)).toList();
  }

  Future<List<ChatMessage>> getChatMessages(String specialistId, String userId) async {
    await _ensurePrefs();
    final String key = '${_messagesKey}_${specialistId}_$userId';
    final List<String> messages = _prefs!.getStringList(key) ?? [];
    return messages.map((msg) => ChatMessage.fromMap(jsonDecode(msg))).toList();
  }

  Future<void> saveChatMessage(String specialistId, String userId, ChatMessage message) async {
    await _ensurePrefs();
    final String key = '${_messagesKey}_${specialistId}_$userId';
    final List<String> messages = _prefs!.getStringList(key) ?? [];
    messages.add(jsonEncode(message.toMap()));
    await _prefs!.setStringList(key, messages);
    
    // Send message through WebSocket
    _wsService.sendMessage(message);
  }

  /// Get WebSocket message stream
  Stream<ChatMessage> get messageStream => _wsService.messageStream;

  /// Specialist Methods
  Future<List<Specialist>> getSpecialists() async {
    // Return mock specialists for now
    return [
      Specialist.fromMap({
        'id': '1',
        'name': 'Dr. John Doe',
        'fullName': 'Dr. John Doe',
        'avatar': 'https://via.placeholder.com/150',
        'specialty': 'General Psychology',
      }),
      Specialist.fromMap({
        'id': '2',
        'name': 'Dr. Jane Smith',
        'fullName': 'Dr. Jane Smith',
        'avatar': 'https://via.placeholder.com/150',
        'specialty': 'Family Therapy',
      }),
    ];
  }

  Future<void> closeSession() async {
    _wsService.disconnect();
    await _ensurePrefs();
    await _prefs!.remove(_userKey);
  }

  Future<void> saveUser(User user) async {
    await _ensurePrefs();
    await _prefs!.setString(_userKey, jsonEncode(user.toMap()));
  }

  Future<User?> getUser() async {
    await _ensurePrefs();
    final String? userData = _prefs!.getString(_userKey);
    if (userData == null) return null;
    return User.fromMap(jsonDecode(userData));
  }

  Future<void> clearData() async {
    await _ensurePrefs();
    await _prefs!.clear();
  }
} 