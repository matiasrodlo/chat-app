import 'dart:convert';
import 'service.dart';
import '../classes/User.dart';
import '../classes/SB_Settings.dart';
import 'local_service.dart';

class ServiceUsers extends Service
{
	static	ServiceUsers	_instance	= ServiceUsers._constructor();
	final LocalService _localService = LocalService();
	
	ServiceUsers._constructor();
	
	factory	ServiceUsers() => _instance;
	
	Future<User> login(String username, String pass) async
	{
		try {
			final user = await _localService.login(username, pass);
			this.startSession(user, 'local_token');
			return user;
		} catch (e) {
			throw Exception('Invalid credentials');
		}
	}
	Future<User> register(Map<String, dynamic> data) async
	{
		try {
			final user = await _localService.register(data);
			return user;
		} catch (e) {
			throw Exception('Registration failed');
		}
	}
	void startSession(User user, String token)
	{
		SB_Settings.saveString('token', token);
		SB_Settings.saveObject('user', user.toMap());
		SB_Settings.setBool('authenticated', true);
	}
	void closeSession() async
	{
		await _localService.closeSession();
		await SB_Settings.saveString('token', '');
		await SB_Settings.saveString('user', '');
		await SB_Settings.setBool('authenticated', false);
	}
	Future<bool> isLoggedIn() async
	{
		bool authenticated = await SB_Settings.getBool('authenticated');
		if( authenticated == null )
			authenticated = false;
		return authenticated;
	}
	Future<User> getCurrentUser() async
	{
		try {
			final user = await _localService.getUser();
			if (user == null) {
				throw Exception('No user found');
			}
			return user;
		} catch (e) {
			throw Exception('Failed to get current user: $e');
		}
	}
}
