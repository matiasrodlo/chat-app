import 'package:flutter/material.dart';
import '../../services/service-user.dart';
import '../../classes/User.dart';
import '../home.dart';

class Login extends StatefulWidget {
	const Login({Key? key}) : super(key: key);
	
	@override
	_LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
	final _formKey = GlobalKey<FormState>();
	final _nicknameController = TextEditingController();
	final _serviceUsers = ServiceUsers();
	bool _isLoading = false;
	
	@override
	void initState() {
		super.initState();
		_serviceUsers.init();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Join Chat'),
				backgroundColor: Colors.white,
				elevation: 0,
				iconTheme: IconThemeData(
					color: Theme.of(context).primaryColor,
				),
			),
			body: SafeArea(
				child: Padding(
					padding: const EdgeInsets.all(16.0),
					child: Form(
						key: _formKey,
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								const Text(
									'Welcome to Local Chat',
									textAlign: TextAlign.center,
									style: TextStyle(
										fontSize: 24,
										fontWeight: FontWeight.bold,
									),
								),
								const SizedBox(height: 8),
								const Text(
									'Enter your nickname to join the chat',
									textAlign: TextAlign.center,
									style: TextStyle(
										fontSize: 16,
										color: Colors.grey,
									),
								),
								const SizedBox(height: 32),
								TextFormField(
									controller: _nicknameController,
									decoration: const InputDecoration(
										labelText: 'Nickname',
										border: OutlineInputBorder(),
										prefixIcon: Icon(Icons.person),
									),
									validator: (value) {
										if (value == null || value.isEmpty) {
											return 'Please enter a nickname';
										}
										if (value.length < 3) {
											return 'Nickname must be at least 3 characters';
										}
										return null;
									},
								),
								const SizedBox(height: 24),
								ElevatedButton(
									onPressed: _isLoading ? null : _joinChat,
									style: ElevatedButton.styleFrom(
										padding: const EdgeInsets.symmetric(vertical: 16),
									),
									child: _isLoading
										? const CircularProgressIndicator()
										: const Text('Join Chat'),
								),
							]
						)
					)
				)
			)
		);
	}

	void _joinChat() async {
		if (!(_formKey.currentState?.validate() ?? false)) {
			return;
		}

		try {
			setState(() => _isLoading = true);
			
			// Create a simple user with just the nickname
			final user = User(
				id: DateTime.now().millisecondsSinceEpoch.toString(),
				email: _nicknameController.text.trim(),
				name: _nicknameController.text.trim(),
			);
			
			await _serviceUsers.saveUser(user);
			
			if (!mounted) return;
			
			Navigator.pushReplacement(
				context,
				MaterialPageRoute(builder: (context) => const HomePage()),
			);
		} catch (e) {
			if (!mounted) return;
			setState(() => _isLoading = false);
			ScaffoldMessenger.of(context).showSnackBar(
				SnackBar(content: Text(e.toString())),
			);
		}
	}

	@override
	void dispose() {
		_nicknameController.dispose();
		super.dispose();
	}
}
