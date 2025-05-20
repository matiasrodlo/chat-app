import 'Specialist.dart';

class Chat {
  String? id;
  String? userId;
  Specialist? specialist;
  String? lastMessage;
  DateTime? lastMessageTime;
  bool? unread;

  Chat({
    this.id,
    this.userId,
    this.specialist,
    this.lastMessage,
    this.lastMessageTime,
    this.unread,
  });

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      userId: map['userId'],
      specialist: map['specialist'] != null ? Specialist.fromMap(map['specialist']) : null,
      lastMessage: map['lastMessage'],
      lastMessageTime: map['lastMessageTime'] != null ? DateTime.parse(map['lastMessageTime']) : null,
      unread: map['unread'],
    );
		}

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'specialist': specialist?.toMap(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'unread': unread,
    };
  }
} 