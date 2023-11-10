import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

class SB_Settings
{
	static Future<void> saveString(String key, String val) async
	{
		var pref = await SharedPreferences.getInstance();
		await pref.setString(key, val);
	}
	static Future<String> getString(String key) async
	{
		var pref = await SharedPreferences.getInstance();
		String value = pref.getString(key);
		
		return value;
	}
	static Future<void> setBool(String key, bool val) async
	{
		var pref = await SharedPreferences.getInstance();
		pref.setBool(key, val);
	}
	static Future<bool> getBool(String key) async
	{
		var pref = await SharedPreferences.getInstance();
		bool value = pref.getBool(key);
		
		return value;
	}
	static Future<void> saveObject(String key, Map<String, dynamic> obj) async
	{
		String _json = json.encode(obj);
		await SB_Settings.saveString(key, _json);
	}
	static Future<dynamic> getObject(String key) async
	{
		String data = await SB_Settings.getString(key);
		if( data == null || data.isEmpty )
			return null;
		return json.decode(data);
	}
}
