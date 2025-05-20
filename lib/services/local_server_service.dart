import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';
import '../classes/ChatMessage.dart';
import '../classes/User.dart';

class LocalServerService {
  static final LocalServerService _instance = LocalServerService._internal();
  factory LocalServerService() => _instance;
  LocalServerService._internal();

  final _messageController = StreamController<ChatMessage>.broadcast();
  final _usersController = StreamController<List<User>>.broadcast();
  final _networkInfo = NetworkInfo();
  
  HttpServer? _server;
  List<WebSocket> _clients = [];
  List<User> _connectedUsers = [];
  User? _currentUser;
  String? _localIp;
  
  Stream<ChatMessage> get messageStream => _messageController.stream;
  Stream<List<User>> get usersStream => _usersController.stream;
  
  Future<void> startServer(User user) async {
    _currentUser = user;
    _localIp = await _networkInfo.getWifiIP();
    
    if (_localIp == null) {
      throw Exception('Not connected to WiFi network');
    }
    
    _server = await HttpServer.bind(_localIp, 8080);
    _server!.listen(_handleConnection);
    
    // Add current user to connected users
    _connectedUsers.add(user);
    _broadcastUserList();
  }
  
  Future<void> connectToServer(String serverIp, User user) async {
    _currentUser = user;
    
    try {
      final socket = await WebSocket.connect('ws://$serverIp:8080');
      _handleClientConnection(socket);
      
      // Send user info to server
      socket.add(jsonEncode({
        'type': 'user_join',
        'user': user.toMap(),
      }));
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
  
  void _handleConnection(HttpRequest request) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      WebSocketTransformer.upgrade(request).then(_handleClientConnection);
    }
  }
  
  void _handleClientConnection(WebSocket socket) {
    _clients.add(socket);
    
    socket.listen(
      (data) {
        final message = jsonDecode(data);
        _handleMessage(socket, message);
      },
      onDone: () {
        _clients.remove(socket);
        _broadcastUserList();
      },
      onError: (error) {
        print('WebSocket error: $error');
        _clients.remove(socket);
        _broadcastUserList();
      },
    );
  }
  
  void _handleMessage(WebSocket sender, Map<String, dynamic> message) {
    switch (message['type']) {
      case 'user_join':
        final user = User.fromMap(message['user']);
        if (!_connectedUsers.any((u) => u.id == user.id)) {
          _connectedUsers.add(user);
          _broadcastUserList();
        }
        break;
        
      case 'chat_message':
        final chatMessage = ChatMessage.fromMap(message['message']);
        _messageController.add(chatMessage);
        _broadcastMessage(chatMessage);
        break;
    }
  }
  
  void _broadcastMessage(ChatMessage message) {
    final messageJson = jsonEncode({
      'type': 'chat_message',
      'message': message.toMap(),
    });
    
    for (var client in _clients) {
      client.add(messageJson);
    }
  }
  
  void _broadcastUserList() {
    final userListJson = jsonEncode({
      'type': 'user_list',
      'users': _connectedUsers.map((u) => u.toMap()).toList(),
    });
    
    for (var client in _clients) {
      client.add(userListJson);
    }
    
    _usersController.add(_connectedUsers);
  }
  
  Future<void> sendMessage(ChatMessage message) async {
    _messageController.add(message);
    _broadcastMessage(message);
  }
  
  Future<List<String>> discoverServers() async {
    final networkPrefix = _localIp?.substring(0, _localIp!.lastIndexOf('.'));
    if (networkPrefix == null) return [];
    
    List<String> servers = [];
    
    // Scan common ports in the local network
    for (var i = 1; i < 255; i++) {
      final ip = '$networkPrefix.$i';
      try {
        final socket = await Socket.connect(ip, 8080, timeout: Duration(milliseconds: 100));
        socket.destroy();
        servers.add(ip);
      } catch (e) {
        // Ignore connection errors
      }
    }
    
    return servers;
  }
  
  Future<void> stopServer() async {
    for (var client in _clients) {
      client.close();
    }
    _clients.clear();
    await _server?.close();
    _server = null;
    _connectedUsers.clear();
    _currentUser = null;
  }
  
  void dispose() {
    stopServer();
    _messageController.close();
    _usersController.close();
  }
} 