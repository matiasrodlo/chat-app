import 'package:flutter/material.dart';
import '../../classes/Chat.dart';
import '../../classes/Specialist.dart';
import '../../colors.dart' as appColors;
import '../../pages/chat.dart' as chatPage;

class ChatConversations extends StatefulWidget
{
	final	Function(bool)?	onHasChats;
	
	ChatConversations({this.onHasChats});
	@override
	_ChatConversationsState	createState() => _ChatConversationsState();
}
class _ChatConversationsState extends State<ChatConversations>
{
	List<Chat>		_items = [];
	
	@override
	void initState()
	{
		_items = [];
		_loadData();
		super.initState();
	}
	void _loadData() async
	{
		// TODO: Replace with your chat loading logic
		// For now, just setState to refresh UI
		setState((){});
	}
	@override
	Widget build(BuildContext context)
	{
		var size = MediaQuery.of(context).size;
		return Container(
			child: _items.isNotEmpty ? ListView(
				children: [
					Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							for (var item in _items)
								Column(
									children: [
										_buildItem(item),
										SizedBox(height: 0),
									]
								),
						]
					)
				]
			) : 
			Container(
				margin: EdgeInsets.only(top: size.height * 0.25, right: size.width * 0.05, left: size.width * 0.05,),
				child: _noData(),
			),
		);
	}
	Widget _noData()
	{
		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				Text(
					'No hay conversaciones',
					textAlign: TextAlign.center,
					style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: appColors.mainColors['blue']),
				),
				SizedBox(height: 20),
				Text(
					'Inicia una conversación para ver tus chats aquí.',
					textAlign: TextAlign.center,
				),
				SizedBox(height: 20),
			]
		);
	}
	Widget _buildItem(Chat chat)
	{
		return Card(
			elevation: 0,
			child: Container(
				child: ListTile(
					leading: Container(
						width: 54,
						height: 54,
						child: CircleAvatar(
							backgroundImage: NetworkImage(chat.specialist?.avatar ?? ''),
							backgroundColor: Colors.grey,
						)
					),
					title: Text(chat.specialist?.fullName ?? 'Especialista'),
					subtitle: Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							Text('Psicólogo - Activo')
						]
					),
					onTap: ()
					{
						Navigator.push(
							context,
							MaterialPageRoute(
								builder: (_) => chatPage.ChatPage(speccho: chat.specialist ?? Specialist()),
							),
						);
					}
				)
			)
		);
	}
}
