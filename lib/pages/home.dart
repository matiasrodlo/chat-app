import 'dart:async';
import 'package:flutter/material.dart';
import '../classes/ChatMessage.dart';
import '../services/lan_service.dart';
import '../models/chat_message.dart';
import 'chat_screen.dart';

class HomePage extends StatefulWidget {
	const HomePage({super.key});

	@override
	State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	final _usernameController = TextEditingController();
	final _lanService = LanService();
	bool _isConnecting = false;

	@override
	void dispose() {
		_usernameController.dispose();
		super.dispose();
	}

	Future<void> _connect() async {
		if (_usernameController.text.trim().isEmpty) return;
		
		setState(() {
			_isConnecting = true;
		});

		try {
			await _lanService.connect(_usernameController.text.trim());
			if (mounted) {
				Navigator.of(context).pushReplacement(
					MaterialPageRoute(
						builder: (context) => const ChatScreen(),
					),
				);
			}
		} catch (e) {
			if (mounted) {
				ScaffoldMessenger.of(context).showSnackBar(
					SnackBar(content: Text('Failed to connect: $e')),
				);
			}
		} finally {
			if (mounted) {
				setState(() {
					_isConnecting = false;
				});
			}
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('LAN Chat'),
			),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						TextField(
							controller: _usernameController,
							decoration: const InputDecoration(
								labelText: 'Username',
								border: OutlineInputBorder(),
							),
							textInputAction: TextInputAction.done,
							onSubmitted: (_) => _connect(),
						),
						const SizedBox(height: 16),
						ElevatedButton(
							onPressed: _isConnecting ? null : _connect,
							child: _isConnecting
								? const CircularProgressIndicator()
								: const Text('Join Chat'),
						),
					],
				),
			),
		);
	}
}
