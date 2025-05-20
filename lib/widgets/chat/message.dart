import 'package:flutter/material.dart';
import '../../classes/ChatMessage.dart';
import '../../services/service-user.dart';

class MessageWidget extends StatelessWidget {
	final ChatMessage message;
	final _userService = ServiceUsers();

	MessageWidget({
		super.key,
		required this.message,
	});

	@override
	Widget build(BuildContext context) {
		final isMe = message.senderId == _userService.getCurrentUserId();

		return Align(
			alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
			child: Container(
				margin: const EdgeInsets.symmetric(
					horizontal: 8,
					vertical: 4,
				),
				padding: const EdgeInsets.symmetric(
					horizontal: 12,
					vertical: 8,
				),
				decoration: BoxDecoration(
					color: isMe ? Colors.blue : Colors.grey[300],
					borderRadius: BorderRadius.circular(16),
				),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(
							message.content,
							style: TextStyle(
								color: isMe ? Colors.white : Colors.black,
							),
						),
						const SizedBox(height: 4),
						Text(
							_formatTime(message.timestamp),
							style: TextStyle(
								fontSize: 12,
								color: isMe ? Colors.white70 : Colors.black54,
							),
						),
					],
				),
			),
		);
	}

	String _formatTime(DateTime time) {
		return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
	}
}
