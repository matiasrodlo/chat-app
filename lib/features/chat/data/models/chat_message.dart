/// ChatMessage model representing a message in a chat
class ChatMessage {
  final String? id;
  final String? content;
  final String? sentBy;
  final DateTime? sentAt;
  final bool? isRead;

  ChatMessage({
    this.id,
    this.content,
    this.sentBy,
    this.sentAt,
    this.isRead,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id']?.toString(),
      content: map['content']?.toString(),
      sentBy: map['sentBy']?.toString(),
      sentAt: map['sentAt'] != null ? DateTime.parse(map['sentAt']) : null,
      isRead: map['isRead'] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'sentBy': sentBy,
      'sentAt': sentAt?.toIso8601String(),
      'isRead': isRead,
    };
  }
} 