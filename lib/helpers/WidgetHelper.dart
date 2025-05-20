import 'package:flutter/material.dart';
import '../colors.dart' as appColors;

class WidgetHelper
{
	static TextStyle getTitleStyle()
	{
		return TextStyle(color: appColors.AppColors.mainColors['blue']);
	}
	static InputDecoration getTextFieldDecoration(String label, [Color? color])
	{
		return InputDecoration(
			labelText: label,
			contentPadding: EdgeInsets.only(top:4, right: 10, bottom: 4, left: 10),
			filled: true,
			fillColor: color,
			//icon: Icon(Icons.supervisor_account, color: Colors.white),
			hintText: label,	
			hintStyle: TextStyle(color: Colors.white),
			focusedBorder: OutlineInputBorder(
				borderRadius: BorderRadius.circular(10),
				borderSide: BorderSide(
					style: BorderStyle.solid,
					color: (color ?? appColors.AppColors.mainColors['gray'])!.withOpacity(0.5),
					//width: 0,
				)
			),
			enabledBorder: OutlineInputBorder(
				borderRadius: BorderRadius.circular(10),
				borderSide: BorderSide(
					style: BorderStyle.solid,
					color: (color ?? appColors.AppColors.mainColors['gray'])!.withOpacity(0.5),
				)
			),
			border: OutlineInputBorder(
				borderRadius: BorderRadius.circular(10),
				borderSide: BorderSide(
					style: BorderStyle.solid,
					color: (color ?? appColors.AppColors.mainColors['gray'])!.withOpacity(0.5),
				)
			),
			errorBorder: OutlineInputBorder(
				borderRadius: BorderRadius.circular(10),
				borderSide: BorderSide(
					style: BorderStyle.solid,
					color: (color ?? appColors.AppColors.mainColors['gray'])!.withOpacity(0.5),
				)
			)
		);
	}
}
