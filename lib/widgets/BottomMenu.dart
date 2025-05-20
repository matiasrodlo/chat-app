import 'package:flutter/material.dart';
import '../colors.dart' as appColors;

class BottomMenu extends StatelessWidget {
	final VoidCallback? onHomePressed;
	final VoidCallback? onChatPressed;
	final VoidCallback? onProfilePressed;
	final VoidCallback? onSettingsPressed;

	const BottomMenu({
		Key? key,
		this.onHomePressed,
		this.onChatPressed,
		this.onProfilePressed,
		this.onSettingsPressed,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Container(
			height: 60,
			decoration: BoxDecoration(
				color: appColors.mainColors['white'],
				boxShadow: [
					BoxShadow(
						color: Colors.black.withOpacity(0.1),
						blurRadius: 10,
						offset: Offset(0, -5),
					),
				],
			),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceAround,
				children: [
					IconButton(
						icon: Icon(Icons.home),
						onPressed: onHomePressed ?? () {},
					),
					IconButton(
						icon: Icon(Icons.chat),
						onPressed: onChatPressed ?? () {},
					),
					IconButton(
						icon: Icon(Icons.person),
						onPressed: onProfilePressed ?? () {},
					),
					IconButton(
						icon: Icon(Icons.settings),
						onPressed: onSettingsPressed ?? () {},
					),
				],
			),
		);
	}
}
