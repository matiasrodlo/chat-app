import '../classes/ChatMessage.dart';

class LanService {
  static final LanService _instance = LanService._internal();
  factory LanService() => _instance;
  LanService._internal();

  Stream<ChatMessage> get messageStream => const Stream.empty();
  Stream<int> get peerCountStream => const Stream.empty();
  bool get isServer => false;
  String? get username => null;
  int get peerCount => 0;

  Future<void> initialize() async {}
  Future<void> sendMessage(String content) async {}
  Future<void> dispose() async {}
} 