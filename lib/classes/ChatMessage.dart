import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ChatMessage
{
	String		id;
	bool		read;
	String		sentBy;
	String		message;
	DateTime	updatedAt;
	DateTime	createdAt;
	
	String get date
	{
		var format = DateFormat('MMM d, K:m aaa');
		return format.format(this.createdAt);
	}
	ChatMessage();
	
	ChatMessage.fromMap(Map data)
	{
		this.loadData(data);
	}
	void loadData(Map data)
	{
		try
		{
			this.id				= data['_id'];
			this.read			= data['read'];
			this.sentBy			= data['sentBy'];
			this.message		= data['message'];
			this.updatedAt		= DateTime.parse(data['updatedAt']);
			this.createdAt		= DateTime.parse(data['createdAt']);
		}
		catch(e)
		{
			print('CHAT MESSAGE ERROR LOADING DATA');
			print(e);
		}
	}
}
