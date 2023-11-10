import 'package:flutter/material.dart';
import '../colors.dart' as appColors;

class WidgetHelper
{
	static TextStyle getTextFieldStyle()
	{
		return TextStyle(color: appColors.mainColors['blue']);
	}
	static InputDecoration getTextFieldDecoration(String hint, [Color bgColor = Colors.transparent])
	{
		return InputDecoration(
			labelText: hint,
			contentPadding: EdgeInsets.only(top:4, right: 10, bottom: 4, left: 10),
			filled: true,
			fillColor: bgColor,
			//icon: Icon(Icons.supervisor_account, color: Colors.white),
			hintText: hint,	
			hintStyle: TextStyle(color: Colors.white),
			focusedBorder: OutlineInputBorder(
				borderRadius: BorderRadius.circular(10),
				borderSide: BorderSide(
					style: BorderStyle.solid,
					color: appColors.mainColors['gray'].withOpacity(0.5),
					//width: 0,
				)
			),
			enabledBorder: OutlineInputBorder(
				borderRadius: BorderRadius.circular(10),
				borderSide: BorderSide(
					style: BorderStyle.solid,
					color: appColors.mainColors['gray'].withOpacity(0.5),
				)
			),
			border: OutlineInputBorder(
				borderRadius: BorderRadius.circular(10),
				borderSide: BorderSide(
					style: BorderStyle.solid,
					color: appColors.mainColors['gray'].withOpacity(0.5),
				)
			)
		);
	}
}
