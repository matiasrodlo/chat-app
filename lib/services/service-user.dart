import 'dart:convert';
import 'service.dart';
import '../classes/User.dart';
import '../classes/SB_Settings.dart';

class ServiceUsers extends Service
{
	static	ServiceUsers	_instance	= ServiceUsers._constructor();
	
	ServiceUsers._constructor();
	
	factory	ServiceUsers() => _instance;
	
	Future<User> login(String username, String pass) async
	{
		var data = {
			'email': username,
			'password': pass,
		};
		//var api = Service();
		var res = await this.post('/auth/login', data, {'Content-Type': 'application/x-www-form-urlencoded'});
		var obj = json.decode(res);
		var user = new User.fromMap( obj['user'] );
		//##save token
		this.startSession(user, obj['token']);
		this.setToken(obj['token']);
		
		return user;
	}
	Future<User> register(Map<String, dynamic> data) async
	{
		var _json = await this.post('/auth/register', data, {'Content-Type': 'application/x-www-form-urlencoded'});
		var obj = json.decode(_json);
		var user = new User.fromMap( obj['user'] );
		
		return user;
	}
	void startSession(User user, String token)
	{
		//##save token
		SB_Settings.saveString('token', token);
		SB_Settings.saveObject('user', user.toMap());
		SB_Settings.setBool('authenticated', true);
	}
	void closeSession() async
	{
		await SB_Settings.saveString('token', '');
		await SB_Settings.saveString('user', '');
		await SB_Settings.setBool('authenticated', false);
		
	}
	Future<bool> isLoggedIn() async
	{
		bool authenticated = await SB_Settings.getBool('authenticated');
		if( authenticated == null )
			authenticated = false;
		this.setToken(await SB_Settings.getString('token'));
		return authenticated;
	}
	Future<User> getCurrentUser() async
	{
		var data = await SB_Settings.getObject('user');
		if( data == null )
			return null;
		var user = User.fromMap(data);
		
		return user;
	}
}
