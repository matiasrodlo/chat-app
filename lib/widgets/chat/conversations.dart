import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/service-hablaqui.dart';
import '../../classes/Specialist.dart';
import '../../classes/Chat.dart';
import '../../colors.dart' as appColors;
import '../button.dart';
import '../../pages/chat.dart' as chatPage;

class ChatConversations extends StatefulWidget
{
	final	Function(bool)	onHasChats;
	
	ChatConversations({this.onHasChats});
	@override
	_ChatConversationsState	createState() => _ChatConversationsState();
}
class _ChatConversationsState extends State<ChatConversations>
{
	int		_requests = 0;
	List<Chat>		_items = [];
	List<Chat>		_myItems = [];
	
	@override
	void initState()
	{
		this._items = [];
		this._loadData();
		super.initState();
	}
	void _loadData() async
	{
		this._items = await ServiceHablaqui().getChats();
		this.setState((){});
		
	}
	@override
	Widget build(BuildContext context)
	{
		var size = MediaQuery.of(context).size;
		return Container(
			child: this._items.length > 0 ? ListView(
				children: [
					Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							Text('Mi especialista', style: TextStyle(color: appColors.mainColors['blue']),),
							SizedBox(height: 10),
							Divider(color: appColors.mainColors['blue']),
							SizedBox(height: 10),
							for(var myItem in this._myItems)
								Column(
									children: [
										this._buildItem(myItem),
										SizedBox(height: 0),
									]
								),
							Text('General'),
							Divider(),
							SizedBox(height: 10),
							for(var item in this._items)
								Column(
									children: [
										this._buildItem(item),
										SizedBox(height: 0),
									]
								),
							/*
							Container(
								child: Column(
									children: [
										
										
										this._items.length <= 0 ? this._noData() : ListView.builder(
											itemCount: this._items.length,
											itemBuilder: (_, index)
											{
												return ;
											}
										)
									]
								)
							)
							*/
						]
					)
				]
			) : 
			Container(
				margin: EdgeInsets.only(top: size.height * 0.25, right: size.width * 0.05, left: size.width * 0.05,),
				child: this._noData(),
			),
			/*
			child: StreamBuilder(
				stream: this._getConversations(),
				builder: (ctx, snapshot)
				{
					if( !snapshot.hasData  )
						return Center(child: CircularProgressIndicator());
						
					if( this._items.length <= 0 )
						return this._noData();
						
					return ListView.builder(
						itemCount: this._items.length,
						itemBuilder: (_, index)
						{
							return this._buildItem(this._items[index]);
						}
					);
				}
			)
			*/
		);
	}
	Widget _noData()
	{
		return Column(
			//mainAxisAlignment: MainAxisAlignment.center,
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				Text('Comienza a hablar con nuestros especialistas', 
					textAlign: TextAlign.center,
					style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: appColors.mainColors['blue'])
				),
				SizedBox(height: 20),
				Text('Orientación psicológica en cualquier momento y lugar. Comienza a mejorar tu vida hoy.',
					textAlign: TextAlign.center,
				),
				SizedBox(height: 20),
				WidgetButton(
					text: 'Buscar ahora',
					callback: this._searchSpecialists,
					color: appColors.mainColors['blue'],
				),
			]
		);
	}
	void _searchSpecialists() async
	{
		//Navigator.of(this.context).pushNamed('/specialists/search');
		String url = 'https://hablaqui.cl/especialistas';
		if (await canLaunch(url)) 
		{
			await launch(url);
		} 
		else 
		{
			print('Could not launch $url');
		}
	}
	Stream<List> _getConversations() async*
	{
		var chats = await ServiceHablaqui().getChats();
		print(chats);
		this._items.addAll( chats );
		yield this._items;
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
							backgroundImage: NetworkImage(chat.specialist.avatar),
							backgroundColor: Colors.grey,
						)
					),
					title: Text(chat.specialist.fullName),
					subtitle: Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							Text('Psicólogo - Activo')
						]
					),
					//trailing: Image.network(speccho.avatar)
					onTap: ()
					{
						Navigator.push(this.context, MaterialPageRoute(builder: (_) => chatPage.ChatPage(speccho: chat.specialist)));
					}
				)
			)
		);
	}
}
