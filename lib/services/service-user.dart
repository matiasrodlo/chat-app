import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/User.dart';

class ServiceUsers {
  static final ServiceUsers _instance = ServiceUsers._internal();
  factory ServiceUsers() => _instance;
  ServiceUsers._internal();

  SharedPreferences? _prefs;
  static const String _userKey = 'current_user';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _ensurePrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  Future<User?> getCurrentUser() async {
    await _ensurePrefs();
    final userJson = _prefs!.getString(_userKey);
    if (userJson == null) return null;
    return User.fromMap(json.decode(userJson));
  }

  String? getCurrentUserId() {
    final userJson = _prefs?.getString(_userKey);
    if (userJson == null) return null;
    final userMap = json.decode(userJson);
    return userMap['id'] as String?;
  }

  Future<void> saveUser(User user) async {
    await _ensurePrefs();
    await _prefs!.setString(_userKey, json.encode(user.toMap()));
  }

  Future<void> logout() async {
    await _ensurePrefs();
    await _prefs!.remove(_userKey);
  }
} 