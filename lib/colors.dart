import 'package:flutter/material.dart';

final mainColors = {
	'blue':			Color(0xff0079ff),
	'lightBlue': 	Color(0xff56b5fc),
	'darkRed': 		Color(0xff781510),
	'orange': 		Color(0xffe4891c),
	'darkRedT': 	Color(0x77781510),
	'gray': 		Color(0xff808080),
	'lightGray':	Color(0xfff3f3f3),
};
var primaryColor = MaterialColor(0xff0079ff,
	<int, Color>{
		50: mainColors['blue'],
		100: mainColors['blue'],
		200: mainColors['blue'],
		300: mainColors['blue'],
		400: mainColors['blue'],
		500: mainColors['blue'],
		600: mainColors['blue'],
		700: mainColors['blue'],
		800: mainColors['blue'],
		900: mainColors['blue'],
	}
);
