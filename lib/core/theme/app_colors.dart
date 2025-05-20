/// Application Color Scheme
/// 
/// This file defines the color palette used throughout the application.
/// It includes both individual colors and a MaterialColor swatch for the primary color.
/// 
/// Colors are defined using hexadecimal values and can be accessed through the
/// mainColors map or the primaryColor MaterialColor swatch.

// Import Flutter's material design package for UI components
import 'package:flutter/material.dart';

/// Application color scheme
class AppColors {
	static const MaterialColor primaryColor = MaterialColor(
		0xFF2196F3,
		<int, Color>{
			50: Color(0xFFE3F2FD),
			100: Color(0xFFBBDEFB),
			200: Color(0xFF90CAF9),
			300: Color(0xFF64B5F6),
			400: Color(0xFF42A5F5),
			500: Color(0xFF2196F3),
			600: Color(0xFF1E88E5),
			700: Color(0xFF1976D2),
			800: Color(0xFF1565C0),
			900: Color(0xFF0D47A1),
		},
	);

	static const Map<String, Color> mainColors = {
		'primary': Color(0xFF2196F3),
		'secondary': Color(0xFF03A9F4),
		'accent': Color(0xFF00BCD4),
		'background': Color(0xFFF5F5F5),
		'surface': Colors.white,
		'error': Color(0xFFE53935),
		'success': Color(0xFF43A047),
		'warning': Color(0xFFFFA000),
		'text': Color(0xFF212121),
		'textSecondary': Color(0xFF757575),
		'divider': Color(0xFFBDBDBD),
	};
}

/// Map of named colors used throughout the application.
/// 
/// Available colors:
/// - blue: Primary blue color (#0079ff)
/// - lightBlue: Lighter shade of blue (#56b5fc)
/// - darkRed: Deep red color (#781510)
/// - orange: Accent orange color (#e4891c)
/// - darkRedT: Semi-transparent dark red
/// - gray: Standard gray (#808080)
/// - lightGray: Light background gray (#f3f3f3)
final Map<String, Color> mainColors = {
	// Primary blue color used for main UI elements
	'blue':			Color(0xFF2196F3),
	// Lighter blue used for secondary elements and hover states
	'lightBlue': 	Color(0xFF64B5F6),
	// Deep red used for warnings and important notifications
	'darkRed': 		Color(0xff781510),
	// Orange used for accent elements and call-to-action buttons
	'orange': 		Color(0xffe4891c),
	// Semi-transparent dark red used for overlays and backgrounds
	'darkRedT': 	Color(0x77781510),
	// Standard gray used for text and borders
	'gray': 		Color(0xFF9E9E9E),
	// Light gray used for backgrounds and disabled states
	'lightGray':	Color(0xFFE0E0E0),
	// Dark gray used for secondary elements and text
	'darkGray': 	Color(0xFF616161),
	// White color used for backgrounds and text
	'white': 		Colors.white,
	// Black color used for text and borders
	'black': 		Colors.black,
};

/// Primary color swatch for the application.
/// 
/// This MaterialColor is used as the primary color throughout the app,
/// particularly in the app's theme. It uses the blue color (#0079ff) as its base
/// and creates different shades for various Material Design states.
var primaryColor = MaterialColor(0xff0079ff,
	<int, Color>{
		// Define all shades of the primary color
		// Note: Currently all shades use the same color
		// This could be enhanced with different shades for each level
		50: mainColors['blue']!,  // Lightest shade
		100: mainColors['blue']!, // Very light shade
		200: mainColors['blue']!, // Light shade
		300: mainColors['blue']!, // Medium-light shade
		400: mainColors['blue']!, // Medium shade
		500: mainColors['blue']!, // Base color
		600: mainColors['blue']!, // Medium-dark shade
		700: mainColors['blue']!, // Dark shade
		800: mainColors['blue']!, // Very dark shade
		900: mainColors['blue']!, // Darkest shade
	}
);
