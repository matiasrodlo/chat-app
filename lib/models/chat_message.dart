class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final Map<String, List<String>> reactions; // emoji -> list of user IDs
  final MessageStatus status;
  final bool isEdited;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.reactions = const {},
    this.status = MessageStatus.sending,
    this.isEdited = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'reactions': reactions,
    'status': status.toString(),
    'isEdited': isEdited,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'],
    senderId: json['senderId'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
    reactions: Map<String, List<String>>.from(json['reactions'] ?? {}),
    status: MessageStatus.values.firstWhere(
      (e) => e.toString() == json['status'],
      orElse: () => MessageStatus.sent,
    ),
    isEdited: json['isEdited'] ?? false,
  );

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? content,
    DateTime? timestamp,
    Map<String, List<String>>? reactions,
    MessageStatus? status,
    bool? isEdited,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      reactions: reactions ?? this.reactions,
      status: status ?? this.status,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  failed
} 