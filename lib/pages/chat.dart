import 'package:flutter/material.dart';
import 'package:flutter_pusher/pusher.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

import '../classes/Specialist.dart';
import '../classes/Chat.dart';
import '../classes/ChatMessage.dart';
import '../colors.dart' as appColors;
import '../widgets/chat/message.dart';
import '../services/service-hablaqui.dart';
import '../classes/SB_Settings.dart';
import '../classes/User.dart';
import '../helpers/WidgetHelper.dart';
import '../config.dart';

class ChatPage extends StatefulWidget
{
	final Specialist	speccho;
	
	ChatPage({@required this.speccho});
	
	@override
	_ChatPageState	createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage>
{
	ScrollController 		_scrollController 	= new ScrollController();
	TextEditingController	_ctrlMessage 		= TextEditingController();
	TextEditingController	channelController	= TextEditingController(text: 'chat');
	TextEditingController	eventController 	= TextEditingController(text: "update");
	TextEditingController	triggerController 	= TextEditingController(text: "client-trigger");
  
	FocusNode				_focusNode;
	User					_user;
	
	List<ChatMessage>		_messages = [];
	double msgWidth;
	
	Channel channel;
	
	double textHeight		= 50;
	@override
	void initState()
	{
		this.loadData();
		super.initState();
		this._focusNode		= FocusNode(
			onKey: (node, event)
			{
				if (event.isKeyPressed(LogicalKeyboardKey.enter)) 
				{
					print('ENTER');
					this.setState(()
					{
						this.textHeight = 100;
					});
				}
				return false;
			}
		);
		
	}
	@override
	void dispose()
	{
		this._focusNode.dispose();
		if( this.channel != null )
			channel.unbind(this.eventController.text);
		Pusher.unsubscribe(this.channelController.text);
		super.dispose();
	}
	void loadData() async
	{
		await this.initPusher();
		this._user = new User.fromMap( await SB_Settings.getObject('user')) ;
		var items = await ServiceHablaqui().getChatMessages(this.widget.speccho.id, this._user.id);
		this._messages.addAll( items );
		
		this.setState((){
			this._scrollDown();
			
		});
	}
	Future<void> initPusher() async 
	{
		try 
		{
			await Pusher.init(
				appConfig['PUSHER_API_KEY'],
				PusherOptions(
					cluster: appConfig['PUSHER_CLUSTER'],
				),
				enableLogging: true
			);
			Pusher.connect(onConnectionStateChange: (x) async 
			{
				print('lastConnectionState = ${x.currentState}');
				try
				{
					this.channel = await Pusher.subscribe(this.channelController.text);
				}
				on PlatformException catch (e) 
				{
					print('SUBSCRIBE ERROR');
					print(e.message);
				}
				
				await this.channel.bind(this.eventController.text, (x) 
				{
					print('lastEvent: $x');
					this._onPusherEvent(x);
				});
				
			}, onError: (x) {
			  debugPrint("Error: ${x.message}");
			});
		} 
		on PlatformException catch (e) 
		{
			print('ERROR');
			print(e.message);
		}
	}
	@override
	Widget build(BuildContext context)
	{
		var size = MediaQuery.of(context).size;
		this.msgWidth = size.width * 0.7;
		
		return Scaffold(
			appBar: AppBar(
				elevation: 0,
				title: Row(
					children: [
						Container(
							height: 50,
							child: CircleAvatar(
								backgroundImage: NetworkImage(this.widget.speccho.avatar),
							)
						),
						SizedBox(width: 10),
						Text(this.widget.speccho.fullName)
					],
				),
				actions: [
					IconButton(
						icon: Image.asset('images/info-icon.png', height: 20),
						onPressed: this._openSpecchoEmail
					)
				]
			),
			body: SafeArea(
				child: Container(
					color: appColors.mainColors['blue'],
					child: Container(
						padding: EdgeInsets.all(10),
						decoration: BoxDecoration(
							
							color: Colors.white,
							borderRadius: BorderRadius.only(
								topRight: Radius.circular(20),
								topLeft: Radius.circular(20),
							)
						),
						child: Column(
							children: [
								Expanded(
									flex: 11,
									child: this._withListView(),
								),
								SizedBox(height: 1),
								Container(
									height: this.textHeight,
									padding: EdgeInsets.only(top: 10),
									child: TextFormField(
										keyboardType: TextInputType.multiline,
										//minLines: 1,
										maxLines: 5,
										//expands: true,
										focusNode: this._focusNode,
										controller: this._ctrlMessage,
										decoration: WidgetHelper.getTextFieldDecoration('Mensaje a ${this.widget.speccho.name}').copyWith(
											//isDense: true,
											contentPadding: EdgeInsets.all(10),
											suffixIcon: Container(
												width: 50,
												child: Row(
													children: [
														/*
														IconButton(
															padding: EdgeInsets.all(8),
															icon: Icon(Icons.mic_none, color: Colors.grey),
															onPressed: ()
															{
															}
														),
														*/
														IconButton(
															padding: EdgeInsets.all(8),
															icon: Image.asset('images/envelop.png', width: 20),
															onPressed: this._sendMessage,
														)
													]
												)
											)
										),
										
									),
								)
							]
						)
					)
				)
			)
		);
	}
	Stream<List> _getMessages() async*
	{
		var items = await ServiceHablaqui().getChatMessages(this.widget.speccho.id, this._user.id);
		this._messages.addAll( items );
		
		yield this._messages;
	}
	Widget _withStreamBuilder()
	{
		return StreamBuilder(
			stream: this._getMessages(),
			builder: (ctx, snapshot)
			{
				if( !snapshot.hasData )
					return Center(child: CircularProgressIndicator());
				
				return this._getListView();
			}
		);
	}
	Widget _withListView()
	{
		return this._getListView();
	}
	Widget _getListView()
	{
		return ListView.builder(
			controller: this._scrollController,
			itemCount: this._messages.length,
			itemBuilder: (_, index)
			{
				return WidgetChatMessage(
					message: this._messages[index],
					isMine: this._user.id == this._messages[index].sentBy,
					width: msgWidth,
					from: this._user.id == this._messages[index].sentBy ? this._user.name : this.widget.speccho.fullName,
				);
			}
		);
	}
	void _sendMessage() async
	{
		if( this._ctrlMessage.text.trim().isEmpty )
			return;
			
		ServiceHablaqui().sendChatMessage(this.widget.speccho.id, this._user.id, this._ctrlMessage.text.trim());
		//this._messages.add( message );
		this._ctrlMessage.text = '';
		//this._focusNode.unfocus();
		this.textHeight = 50;
		this.setState((){});
	}
	void _onPusherEvent(event)
	{
		print('onPusherEvent');
		print(event.data);
		var obj = json.decode(event.data);
		
		this.setState(()
		{
			this._messages.add( new ChatMessage.fromMap(obj['content']) );
			this._scrollDown();
		});
	}
	void _scrollDown()
	{
		Timer(
			Duration(seconds: 1),
			() => this._scrollController.jumpTo(this._scrollController.position.maxScrollExtent),
		);
	}
	void _openSpecchoEmail() async
	{
		String url = 'mailto:soporte@hablaqui.cl?subject=';//'mailto:${this.widget.speccho.email}?subject=';
		if (await canLaunch(url)) 
		{
			await launch(
				url,
				//forceSafariVC: false,
				//forceWebView: false,
				//headers: <String, String>{'my_header_key': 'my_header_value'},
			);
		} 
		else 
		{
			print('Could not launch $url');
		}
	}
}
