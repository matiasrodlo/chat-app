import 'package:flutter/material.dart';

final Map appConfig = {
	'PUSHER_API_KEY': 'f7e1381e2482c3db4a61',
	'PUSHER_CLUSTER': 'us2'
};

/// Application configuration constants
class AppConfig {
	static const String appName = 'Chat App';
	static const String appVersion = '1.0.0';
	
	// API Configuration
	static const String baseUrl = 'http://localhost:3000';
	
	// Storage Keys
	static const String userKey = 'user_data';
	static const String messagesKey = 'chat_messages';
	static const String chatsKey = 'chats';
	static const String usersKey = 'users';
}
