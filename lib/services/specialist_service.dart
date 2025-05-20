import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/Specialist.dart';

class SpecialistService {
  static final SpecialistService _instance = SpecialistService._internal();
  factory SpecialistService() => _instance;
  SpecialistService._internal();

  SharedPreferences? _prefs;
  static const String _specialistsKey = 'specialists';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs!.containsKey(_specialistsKey)) {
      // Initialize with test psychologist
      final mockSpecialists = [
        {
          'id': '1',
          'name': 'Dr. Smith',
          'fullName': 'John Smith, Psychologist',
          'email': 'smith@example.com',
          'password': 'smith123',
          'avatar': 'https://randomuser.me/api/portraits/men/1.jpg',
          'state': 'active',
          'role': 'specialist',
        },
        {
          'id': '2',
          'name': 'Dr. Johnson',
          'fullName': 'Sarah Johnson, Psychologist',
          'email': 'johnson@example.com',
          'password': 'johnson123',
          'avatar': 'https://randomuser.me/api/portraits/women/1.jpg',
          'state': 'active',
          'role': 'specialist',
        }
      ];
      await _prefs!.setString(_specialistsKey, json.encode(mockSpecialists));
      // Also save to users collection for login compatibility
      await _prefs!.setString('specialists', json.encode(mockSpecialists));
    }
  }

  Future<void> _ensurePrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  Future<List<Specialist>> getSpecialists() async {
    await _ensurePrefs();
    final specialistsJson = _prefs!.getString(_specialistsKey) ?? '[]';
    final specialists = List<Map<String, dynamic>>.from(json.decode(specialistsJson));
    return specialists.map((s) => Specialist.fromMap(s)).toList();
  }

  Future<Specialist?> getSpecialistById(String id) async {
    final specialists = await getSpecialists();
    return specialists.firstWhere(
      (s) => s.id == id,
      orElse: () => throw Exception('Specialist not found'),
    );
  }
} 