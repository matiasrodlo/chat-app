import 'dart:async';
import '../classes/ChatMessage.dart';

/// WebSocket service for real-time communication
class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal();

  /// Returns an empty stream since we're not using real WebSocket connections
  Stream<ChatMessage> get messageStream => const Stream.empty();

  /// No-op connect method
  Future<void> connect() async {
    // TODO: Implement WebSocket connection
  }

  /// No-op send message method
  Future<void> sendMessage(String message) async {
    // TODO: Implement message sending
  }

  /// No-op disconnect method
  Future<void> disconnect() async {
    // TODO: Implement WebSocket disconnection
  }

  void onMessage(Function(dynamic) callback) {
    // TODO: Implement message receiving
  }
} 