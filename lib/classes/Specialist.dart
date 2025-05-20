class Specialist {
  String? id;
  String? name;
  String? fullName;
  String? email;
  String? avatar;
  String? state;
  String? role;

  Specialist({
    this.id,
    this.name,
    this.fullName,
    this.email,
    this.avatar,
    this.state,
    this.role,
  });

  factory Specialist.fromMap(Map<String, dynamic> map) {
    return Specialist(
      id: map['id'],
      name: map['name'],
      fullName: map['fullName'],
      email: map['email'],
      avatar: map['avatar'],
      state: map['state'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'fullName': fullName,
      'email': email,
      'avatar': avatar,
      'state': state,
      'role': role,
    };
  }
} 