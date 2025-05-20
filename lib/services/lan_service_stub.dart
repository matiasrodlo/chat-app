// This file is a stub for dart:io on web.
// It provides dummy implementations for all dart:io types used in lan_service.dart.

class HttpServer {
  Future<void> close() async {}
  void listen(Function(HttpRequest) onRequest) {}
}

class WebSocket {
  void add(String data) {}
  void close() {}
  void listen(Function(dynamic) onData, {Function()? onDone}) {}
}

class HttpRequest {
  bool get isUpgradeRequest => false;
}

class InternetAddress {
  static InternetAddress get anyIPv4 => InternetAddress();
}

class WebSocketTransformer {
  static bool isUpgradeRequest(HttpRequest request) => false;
  static Future<WebSocket> upgrade(HttpRequest request) async => WebSocket();
} 