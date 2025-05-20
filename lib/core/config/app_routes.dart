/// Application Routes Configuration
/// 
/// This file defines all the routes used in the application. Each route is mapped
/// to its corresponding widget/page component.
/// 
/// Available routes:
/// - '/': Welcome screen (initial route)
/// - '/home': Main chat interface
/// - '/login': User login page
/// - '/specialists/search': Specialist search interface

// Import Flutter's material design package for UI components
import 'package:flutter/material.dart';
// Import page components
import '../../../pages/users/login.dart';
import '../../../pages/home.dart';
import '../../../pages/chat.dart';

/// Application routes configuration
class AppRoutes {
	static const String welcome = '/';
	static const String login = '/login';
	static const String home = '/home';
	static const String chat = '/chat';

	static Map<String, WidgetBuilder> get routes => {
		welcome: (context) => const Login(),
		login: (context) => const Login(),
		home: (context) => const HomePage(),
		chat: (context) => const ChatPage(),
	};
}
