import 'dart:async';
import 'dart:convert';
import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/chat_message.dart';

class LanService {
  static final LanService _instance = LanService._internal();
  factory LanService() => _instance;
  LanService._internal();

  // Get local IP address
  Future<String> _getLocalIpAddress() async {
    if (kIsWeb) {
      // For web, always use localhost
      return '127.0.0.1';
    } else {
      // For native platforms, use localhost
      return '127.0.0.1';
    }
  }

  WebSocketChannel? _channel;
  String? _username;
  bool _isConnected = false;
  int _peerCount = 0;
  final _messageController = StreamController<ChatMessage>.broadcast();
  final _peerCountController = StreamController<int>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();
  
  // Message tracking
  final Map<String, ChatMessage> _messages = {}; // Track all messages by ID
  final List<ChatMessage> _messageQueue = []; // Queue for offline messages
  Timer? _reconnectTimer;
  Timer? _messageQueueTimer;
  static const _reconnectInterval = Duration(seconds: 5);
  static const _messageQueueInterval = Duration(seconds: 2);

  Stream<ChatMessage> get messages => _messageController.stream;
  Stream<int> get peerCount => _peerCountController.stream;
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  bool get isConnected => _isConnected;
  int get peerCountValue => _peerCount;
  String? get username => _username;

  Future<void> connect(String username) async {
    _username = username;
    final ipAddress = await _getLocalIpAddress();
    final wsUrl = 'ws://$ipAddress:8080';
    print('Connecting to WebSocket at: $wsUrl');
    _setupWebSocket(wsUrl);
    _startMessageQueueTimer();
  }

  void _setupWebSocket(String wsUrl) {
    try {
      _channel?.sink.close(); // Close existing connection if any
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          if (data['type'] == 'count') {
            _peerCount = data['count'];
            _peerCountController.add(_peerCount);
          } else if (data['type'] == 'delivery') {
            // Handle delivery confirmation
            final messageId = data['messageId'];
            if (_messages.containsKey(messageId)) {
              final originalMessage = _messages[messageId]!;
              if (originalMessage.status != MessageStatus.delivered) {
                final updatedMessage = originalMessage.copyWith(status: MessageStatus.delivered);
                _messages[messageId] = updatedMessage;
                _messageController.add(updatedMessage);
              }
            }
          } else if (data['type'] == 'history') {
            // Handle message history
            final messages = (data['messages'] as List)
                .map((m) => ChatMessage.fromJson(m))
                .toList();
            for (var message in messages) {
              if (!_messages.containsKey(message.id)) {
                _messages[message.id] = message;
                _messageController.add(message);
              }
            }
          } else {
            // Handle chat message
            final chatMessage = ChatMessage.fromJson(data);
            if (!_messages.containsKey(chatMessage.id)) {
              _messages[chatMessage.id] = chatMessage;
              _messageController.add(chatMessage);
            }
          }
          
          // Update connection status to connected when we receive any message
          if (!_isConnected) {
            _isConnected = true;
            _connectionStatusController.add(true);
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
          _handleDisconnection();
        },
        onDone: () {
          print('WebSocket connection closed');
          _handleDisconnection();
        },
        cancelOnError: false,
      );
      
      // Set initial connection status
      _isConnected = true;
      _connectionStatusController.add(true);
    } catch (e) {
      print('Failed to connect: $e');
      _handleDisconnection();
    }
  }

  void _handleDisconnection() {
    if (_isConnected) {
      _isConnected = false;
      _connectionStatusController.add(false);
      _startReconnectTimer();
    }
  }

  void _startReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer.periodic(_reconnectInterval, (timer) async {
      if (!_isConnected) {
        print('Attempting to reconnect...');
        final ipAddress = await _getLocalIpAddress();
        final wsUrl = 'ws://$ipAddress:8080';
        _setupWebSocket(wsUrl);
      } else {
        timer.cancel();
      }
    });
  }

  void _startMessageQueueTimer() {
    _messageQueueTimer?.cancel();
    _messageQueueTimer = Timer.periodic(_messageQueueInterval, (timer) {
      if (_isConnected && _messageQueue.isNotEmpty) {
        _processMessageQueue();
      }
    });
  }

  void _processMessageQueue() {
    while (_messageQueue.isNotEmpty) {
      final message = _messageQueue.removeAt(0);
      _sendMessageToServer(message);
    }
  }

  Future<void> sendMessage(String content) async {
    if (_username == null) return;
    
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _username!,
      content: content,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );
    
    // Store message and show it locally
    _messages[message.id] = message;
    _messageController.add(message);
    
    // Add to queue and try to send
    _messageQueue.add(message);
    if (_isConnected) {
      _processMessageQueue();
    }
  }

  void _sendMessageToServer(ChatMessage message) {
    if (!_isConnected) {
      _messageQueue.add(message);
      return;
    }

    try {
      final messageJson = jsonEncode(message.toJson());
      _channel?.sink.add(messageJson);
      
      // Update message status to sent only if it's still in sending state
      if (_messages[message.id]?.status == MessageStatus.sending) {
        final updatedMessage = message.copyWith(status: MessageStatus.sent);
        _messages[message.id] = updatedMessage;
        _messageController.add(updatedMessage);
      }
    } catch (e) {
      print('Error sending message: $e');
      _messageQueue.add(message);
      _handleDisconnection();
    }
  }

  Future<void> addReaction(String messageId, String emoji) async {
    if (!_isConnected || _username == null) return;
    
    final reactionData = {
      'type': 'reaction',
      'messageId': messageId,
      'emoji': emoji,
      'userId': _username,
    };
    
    _channel?.sink.add(jsonEncode(reactionData));
  }

  void dispose() {
    _reconnectTimer?.cancel();
    _messageQueueTimer?.cancel();
    _channel?.sink.close();
    _messageController.close();
    _peerCountController.close();
    _connectionStatusController.close();
  }
} 