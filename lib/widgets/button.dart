import 'package:flutter/material.dart';

class WidgetButton extends StatelessWidget
{
	String text;
	void Function()	callback;
	String type 	= 'primary';
	Widget			icon;
	Color			color;
	final bool			bordered;
	final bgColor;
	
	WidgetButton({
		this.text, Function() this.callback, 
		this.type = 'primary', 
		this.icon = null, 
		this.color = null, 
		this.bordered = false,
		this.bgColor = Colors.white
	});
	
	void _onTap()
	{
		if( this.callback != null )
			this.callback();
	}
	@override
	Widget build(BuildContext context)
	{
		dynamic btn_color = Colors.red;
		
		if( this.type == 'primary')
			btn_color = Color(0xffff5c1e);
		if( this.type == 'secondary')
			btn_color = Colors.green;
		else if( this.type == 'warning' )
			btn_color = Colors.orange;
		
			
		return InkWell(
			onTap: this._onTap,
			child: Container(
				height: 50,
				decoration: !this.bordered ? BoxDecoration(
					color: this.color ?? btn_color,
					//border: new Border.all(color: Colors.white, width:1),
					borderRadius: BorderRadius.circular(25),
				)
				:
				BoxDecoration(
					color: this.bgColor,
					border: new Border.all(color: this.color ?? btn_color, width:1),
					borderRadius: BorderRadius.circular(25),
				),
				child: Center(
					child: Text(this.text, style: TextStyle(fontSize: 18, color: this.bordered ? this.color ?? btn_color : Colors.white, fontWeight: FontWeight.bold))
				)
			)
		);
	}
}
