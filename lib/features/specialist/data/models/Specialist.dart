/// Specialist model representing a chat specialist
class Specialist {
  final String? id;
  final String? name;
  final String? fullName;
  final String? avatar;
  final String? state;
  final bool? google;
  final String? role;

  Specialist({
    this.id,
    this.name,
    this.fullName,
    this.avatar,
    this.state,
    this.google,
    this.role,
  });

  factory Specialist.fromMap(Map<String, dynamic> map) {
    return Specialist(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      fullName: map['fullName']?.toString(),
      avatar: map['avatar']?.toString(),
      state: map['state']?.toString(),
      google: map['google'] as bool?,
      role: map['role']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'fullName': fullName,
      'avatar': avatar,
      'state': state,
      'google': google,
      'role': role,
    };
  }
} 