import 'dart:convert';
import 'service.dart';
import '../classes/Specialist.dart';
import '../classes/Chat.dart';
import '../classes/ChatMessage.dart';

class ServiceHablaqui extends Service
{
	static	ServiceHablaqui	_instance	= ServiceHablaqui._constructor();
	
	ServiceHablaqui._constructor();
	
	factory	ServiceHablaqui() => _instance;
	
	Future<List<Specialist>>	getSpecialists() async
	{
		String _json 	= await this.get('/specialists/all');
		var items 		= <Specialist>[];
		var obj 		= json.decode(_json);
		
		obj['specialists'].forEach( (d) => items.add( new Specialist.fromMap(d) ));
		
		return items;
	}
	Future<List<Chat>> getChats() async
	{
		String _json	= await this.get('/chat/get-chats');
		print(_json);
		var obj			= json.decode(_json);
		var items		= <Chat>[];
		obj['chats'].forEach( (c) => items.add( new Chat.fromMap(c) ) );
		
		return items;
	}
	Future<List<ChatMessage>> getChatMessages(String specchoId, String userId) async
	{
		String _json	= await this.get('/chat/get-messages/' + specchoId + '/' + userId);
		var obj			= json.decode(_json);
		
		var items = <ChatMessage>[];
		obj['messages']['messages'].forEach( (m) => items.add( new ChatMessage.fromMap(m) ) );
		
		return items;
	}
	Future<ChatMessage> sendChatMessage(String specchoId, String userId, String message) async
	{
		var data = {
			'content': message,
		};
		String _json = await this.post('/chat/send-message/$specchoId/$userId', data, {'Content-Type': 'application/x-www-form-urlencoded'});
		
		var obj = json.decode(_json);
		
		return new ChatMessage.fromMap( obj['chat']['messages'].last );
	}
}
