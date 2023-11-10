import 'package:flutter/material.dart';
import '../../classes/ChatMessage.dart';
import '../../colors.dart' as appColors;

class WidgetChatMessage extends StatelessWidget
{
	final	ChatMessage	message;
	final	bool		isMine;
	final	String		from;
	final	double		width;
	
	WidgetChatMessage({@required this.message, this.isMine = false, this.from = 'Desconocido', this.width = 200});
	
	Widget build(BuildContext context)
	{
		double fontSize = 10;
		
		return Align(
			alignment: this.isMine ? Alignment.topRight : Alignment.topLeft,
			child: Container(
				width: this.width,
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						Row(
							children: [
								Expanded(
									child: Text(
										this.message.date,
										style: TextStyle(
											color: Colors.black.withOpacity(0.38),
											fontSize: fontSize
										)
									)
								),
								SizedBox(width: 10),
								Expanded(child: Text(
									this.from,
									style: TextStyle(
										color: Colors.black.withOpacity(0.38),
										fontSize: fontSize
									),
									textAlign: TextAlign.right)
								),
							]
						),
						SizedBox(height: 5),
						Container(
							decoration: BoxDecoration(
								color: this.isMine ? appColors.mainColors['blue'] : Color(0xffbdbdbd),
								borderRadius: BorderRadius.circular(10),
							),
							padding: EdgeInsets.all(10),
							child: Text(this.message.message, 
								style: TextStyle(
									color: this.isMine ? Colors.white : Color(0xff424242)
								)
							)
						),
						SizedBox(height: 10),
					]
				)
			)
		);
	}
}
