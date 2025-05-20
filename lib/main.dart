/// ChatApp - A Real-time Chat Application
/// 
/// This is the main entry point of the application. It sets up the app's theme,
/// routes, and initial configuration.
/// 
/// The app uses Spanish (es_ES) as the default locale and implements a Material
/// Design theme with custom colors.

// Import Flutter's material design package for UI components
import 'package:flutter/material.dart';
// Import intl package for internationalization
import 'package:intl/intl.dart';
// Import date formatting utilities
import 'package:intl/date_symbol_data_local.dart';
// Import custom colors
import 'core/theme/app_colors.dart';
// Import application routes
import 'core/config/app_routes.dart';
// Import application configuration
import 'core/config/app_config.dart';
// Import local service
import 'shared/services/storage_service.dart';
import 'pages/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'services/service-user.dart';
// Import dart:io for Platform
import 'dart:io' if (dart.library.html) 'dart:html' as platform;

/// The main entry point of the application.
/// 
/// Initializes the app with Spanish locale and date formatting.
void main() async {
	// Ensure Flutter is initialized
	WidgetsFlutterBinding.ensureInitialized();
	
	// Set preferred orientations
	SystemChrome.setPreferredOrientations([
		DeviceOrientation.portraitUp,
		DeviceOrientation.portraitDown,
	]);

	// Configure window size for desktop only when not running on web
	if (!kIsWeb) {
		setWindowTitle('Chat App');
		setWindowMinSize(const Size(400, 600));
	}

	// Configure web URL strategy
	if (kIsWeb) {
		setUrlStrategy(PathUrlStrategy());
	}

	// Initialize services
	final userService = ServiceUsers();
	await userService.init();
	
	// Initialize local service
	final localService = StorageService();
	await localService.init();
	
	// Set default locale to Spanish (Spain)
	Intl.defaultLocale = 'es_ES';
	// Initialize date formatting for the Spanish locale
	await initializeDateFormatting();
	// Launch the application
	runApp(const MyApp());
}

/// The root widget of the application.
/// 
/// This widget sets up the MaterialApp with:
/// - Custom theme using primary color from colors.dart
/// - Application routes defined in routes.dart
/// - Debug banner disabled
/// - Initial route set to '/login'
class MyApp extends StatelessWidget 
{
	/// Creates the root widget of the application.
	const MyApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
		// Return the MaterialApp widget which serves as the root of the widget tree
    return MaterialApp(
			// Set the application title
			title: 'LAN Chat',
			// Configure the app's theme
      theme: ThemeData(
				useMaterial3: true,
				colorScheme: ColorScheme.fromSeed(
					seedColor: AppColors.mainColors['primary']!,
					background: AppColors.mainColors['background']!,
					surface: AppColors.mainColors['surface']!,
					error: AppColors.mainColors['error']!,
				),
				appBarTheme: AppBarTheme(
					backgroundColor: AppColors.mainColors['primary'],
					foregroundColor: Colors.white,
					elevation: 0,
				),
				elevatedButtonTheme: ElevatedButtonThemeData(
					style: ElevatedButton.styleFrom(
						backgroundColor: AppColors.mainColors['primary'],
						foregroundColor: Colors.white,
						padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
						shape: RoundedRectangleBorder(
							borderRadius: BorderRadius.circular(12),
						),
					),
				),
				inputDecorationTheme: InputDecorationTheme(
					filled: true,
					fillColor: AppColors.mainColors['surface'],
					border: OutlineInputBorder(
						borderRadius: BorderRadius.circular(12),
						borderSide: BorderSide(color: AppColors.mainColors['divider']!),
					),
					enabledBorder: OutlineInputBorder(
						borderRadius: BorderRadius.circular(12),
						borderSide: BorderSide(color: AppColors.mainColors['divider']!),
					),
					focusedBorder: OutlineInputBorder(
						borderRadius: BorderRadius.circular(12),
						borderSide: BorderSide(color: AppColors.mainColors['primary']!),
					),
					contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
				),
				textTheme: TextTheme(
					titleLarge: TextStyle(
						color: AppColors.mainColors['text'],
						fontSize: 24,
						fontWeight: FontWeight.bold,
					),
					titleMedium: TextStyle(
						color: AppColors.mainColors['text'],
						fontSize: 20,
						fontWeight: FontWeight.w600,
					),
					bodyLarge: TextStyle(
						color: AppColors.mainColors['text'],
						fontSize: 16,
					),
					bodyMedium: TextStyle(
						color: AppColors.mainColors['textSecondary'],
						fontSize: 14,
					),
				),
			),
			// Disable the debug banner in the top-right corner
		debugShowCheckedModeBanner: false,
			// Define all available routes in the application
			home: const HomePage(),
		);
	}
}

class NotSupportedPage extends StatelessWidget {
	const NotSupportedPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('LAN Chat'),
				backgroundColor: Colors.blue,
			),
			body: Center(
				child: Padding(
					padding: const EdgeInsets.all(20.0),
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							const Icon(
								Icons.computer,
								size: 64,
								color: Colors.blue,
							),
							const SizedBox(height: 20),
							const Text(
								'LAN Chat is not available on web browsers',
								style: TextStyle(
									fontSize: 24,
									fontWeight: FontWeight.bold,
								),
								textAlign: TextAlign.center,
							),
							const SizedBox(height: 10),
							const Text(
								'Please run this app on Windows, macOS, Linux, Android, or iOS to use the LAN chat features.',
								style: TextStyle(
									fontSize: 16,
									color: Colors.grey,
								),
								textAlign: TextAlign.center,
							),
							const SizedBox(height: 30),
							ElevatedButton.icon(
								onPressed: () {
									// You could add a link to download the desktop version here
								},
								icon: const Icon(Icons.download),
								label: const Text('Download Desktop Version'),
								style: ElevatedButton.styleFrom(
									padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
								),
							),
						],
					),
				),
			),
    );
  }
}
