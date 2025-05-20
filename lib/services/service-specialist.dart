import 'dart:convert';
import 'package:shared_preferences.dart';
import '../models/specialist.dart';

class SpecialistService {
  SharedPreferences? _prefs;
  
  Future<void> _ensurePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  Future<List<Specialist>> getSpecialists() async {
    await _ensurePrefs();
    
    // Get all users and filter specialists
    final usersJson = _prefs!.getString('users') ?? '[]';
    final users = List<Map<String, dynamic>>.from(json.decode(usersJson));
    
    // Filter users with role 'specialist' and convert to Specialist objects
    return users
        .where((user) => user['role'] == 'specialist')
        .map((user) => Specialist.fromMap(user))
        .toList();
  }
  
  Future<Specialist?> getSpecialistById(String id) async {
    final specialists = await getSpecialists();
    return specialists.firstWhere(
      (s) => s.id == id,
      orElse: () => throw Exception('Specialist not found'),
    );
  }
  
  Future<void> saveSpecialist(Specialist specialist) async {
    await _ensurePrefs();
    
    // Get all users
    final usersJson = _prefs!.getString('users') ?? '[]';
    final users = List<Map<String, dynamic>>.from(json.decode(usersJson));
    
    // Find and update the specialist
    final index = users.indexWhere((u) => u['id'] == specialist.id);
    if (index != -1) {
      users[index] = specialist.toMap();
      await _prefs!.setString('users', json.encode(users));
    }
  }
} 