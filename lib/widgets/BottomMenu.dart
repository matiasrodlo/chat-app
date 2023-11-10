import 'package:flutter/material.dart';

class BottomMenu extends StatefulWidget
{
	@override
	_BottomMenustate	createState() => _BottomMenustate();
}

class _BottomMenustate extends State<BottomMenu>
{
	@override
	void initState()
	{
		super.initState();
	}
	@override
	Widget build(BuildContext context)
	{
		return Container(
			child: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					IconButton(
						icon: Icon(Icons.chat_bubble_outline)
					)
				]
			)
		);
	}
}
