import 'package:flutter/material.dart';
import '../colors.dart' as appColors;

class WidgetButton extends StatelessWidget {
	final String text;
	final VoidCallback onPressed;
	final Color? color;
	final Color? backgroundColor;
	final bool bordered;
	final IconData? icon;
	final double width;
	final double height;

	const WidgetButton({
		Key? key,
		required this.text,
		required this.onPressed,
		this.color,
		this.backgroundColor,
		this.bordered = false,
		this.icon,
		this.width = 200,
		this.height = 50,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Container(
			width: width,
			height: height,
			child: ElevatedButton(
				onPressed: onPressed,
				style: ElevatedButton.styleFrom(
					backgroundColor: backgroundColor ?? appColors.AppColors.mainColors['blue'],
					side: bordered ? BorderSide(color: color ?? appColors.AppColors.mainColors['blue']!) : null,
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(8),
					),
				),
				child: Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						if (icon != null) ...[
							Icon(icon),
							SizedBox(width: 8),
						],
						Text(text),
					],
				),
			),
		);
	}
}
