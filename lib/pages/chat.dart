import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

import '../classes/Specialist.dart';
import '../classes/Chat.dart';
import '../classes/ChatMessage.dart';
import '../colors.dart' as appColors;
import '../widgets/chat/message.dart';
import '../services/local_service.dart';
import '../classes/SB_Settings.dart';
import '../classes/User.dart';
import '../helpers/WidgetHelper.dart';
import '../config.dart';
import '../services/chat_service.dart';
import '../services/service-user.dart';
import '../widgets/chat/message_input.dart';

class ChatPage extends StatefulWidget {
	const ChatPage({super.key});
	
	@override
	State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
	final _userService = ServiceUsers();
	final _chatService = ChatService();
	final _messageController = TextEditingController();
	List<ChatMessage> _messages = [];
	bool _isLoading = true;

	@override
	void initState() {
		super.initState();
		_loadMessages();
	}

	Future<void> _loadMessages() async {
		try {
			final messages = await _chatService.getMessages();
			setState(() {
				_messages = messages;
				_isLoading = false;
			});
		} catch (e) {
			setState(() => _isLoading = false);
			if (mounted) {
				ScaffoldMessenger.of(context).showSnackBar(
					SnackBar(content: Text('Error loading messages: $e')),
				);
	}
		}
	}

	void _sendMessage(String message) async {
		if (message.trim().isEmpty) return;
		
		final currentUser = await _userService.getCurrentUser();
		if (currentUser == null) return;

		try {
			await _chatService.sendMessage(currentUser.id, message);
			_messageController.clear();
			_loadMessages();
		} catch (e) {
			if (mounted) {
				ScaffoldMessenger.of(context).showSnackBar(
					SnackBar(content: Text('Error sending message: $e')),
				);
		}
	}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Chat'),
			),
			body: _isLoading
					? const Center(child: CircularProgressIndicator())
					: Column(
							children: [
								Expanded(
								child: ListView.builder(
									reverse: true,
									itemCount: _messages.length,
									itemBuilder: (context, index) {
										final message = _messages[index];
										return MessageWidget(message: message);
									},
								),
							),
							MessageInput(
								controller: _messageController,
								onSend: _sendMessage,
							),
						],
					),
		);
	}

	@override
	void dispose() {
		_messageController.dispose();
		super.dispose();
			}

	// void _openSpecchoEmail() async
	// {
	// 	final Uri emailLaunchUri = Uri(
	// 		scheme: 'mailto',
	// 		path: '',
	// 		queryParameters: {
	// 			'subject': 'Consulta desde HablaQui',
	// 		},
	// 	);
	//
	// 	if (await canLaunch(emailLaunchUri.toString())) {
	// 		await launch(emailLaunchUri.toString());
	// 	} else {
	// 		print('Could not launch email');
	// 	}
	// }
}
