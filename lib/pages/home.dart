import 'package:flutter/material.dart';
import '../services/service-user.dart';
import '../classes/SB_Settings.dart';
import '../colors.dart' as appColors;
import '../widgets/button.dart';
import '../widgets/chat/conversations.dart';
import '../widgets/BottomMenu.dart';
import '../helpers/WidgetHelper.dart';

class Home extends StatefulWidget
{
	_HomeState	createState() => _HomeState();
}

class _HomeState extends State<Home>
{
	String 		_title;
	bool	_loaded	= false;
	
	@override
	void initState()
	{
		this._title = 'Hablaqui';
		this._loadData();
	}
	void _loadData() async
	{
		var user = await ServiceUsers().getCurrentUser();
		print(user);
		if( user != null )
		{
			this._title = 'Hola ' + user.name;
		}
		this.setState(()
		{
			this._loaded = true;
		});
	}
	@override
	Widget build(BuildContext context)
	{
		return Scaffold(
			appBar: AppBar(title: Text(this._title), elevation: 0,),
			drawer: Drawer(
				child: ListView(
					children: [
						DrawerHeader(
							decoration: BoxDecoration(
								color: Colors.white,
							),
							child: Center(
								child: Image.asset('images/logo-text.png', fit: BoxFit.cover,),
							)
						),
						ListTile(
							title: Text('Cerrar Sesión'),
							onTap: this._closeSession
						)
					]
				)
			),
			body: Container(
				color: appColors.mainColors['blue'],
				child: Container(
					//padding: EdgeInsets.all(10),
					decoration: BoxDecoration(
						
						color: Colors.white,
						borderRadius: BorderRadius.only(
							topRight: Radius.circular(20),
							topLeft: Radius.circular(20),
						)
					),
					child: Column(
						children: [
							Container(
								padding: EdgeInsets.all(15),
								child: TextFormField(
									
									decoration: WidgetHelper.getTextFieldDecoration('', appColors.mainColors['lightGray']).copyWith(
										hintText: 'Buscar',
										hintStyle: TextStyle(color: Color(0xffafafaf)),
										prefixIcon: Icon(Icons.search, color: Color(0xffafafaf)),
										focusedBorder: OutlineInputBorder(
											borderRadius: BorderRadius.circular(10),
											borderSide: BorderSide(
												style: BorderStyle.solid,
												color: appColors.mainColors['lightGray'],
												//width: 0,
											)
										),
										enabledBorder: OutlineInputBorder(
											borderRadius: BorderRadius.circular(10),
											borderSide: BorderSide(
												style: BorderStyle.solid,
												color: appColors.mainColors['lightGray'],
											)
										),
										border: OutlineInputBorder(
											borderRadius: BorderRadius.circular(10),
											borderSide: BorderSide(
												style: BorderStyle.solid,
												color: appColors.mainColors['lightGray'],
											)
										)
									),
								)
							),
							SizedBox(height: 10),
							Expanded(
								child: Container(
									padding: EdgeInsets.all(10),
									child: this._loaded ? ChatConversations() : SizedBox(height: 0),
								)
							),
							//BottomMenu(),
						]
					)
				)
			)
		);
	}
	void _closeSession() async
	{
		await ServiceUsers().closeSession();
		Navigator.of(this.context).pushNamedAndRemoveUntil('/', (_) => false);
	}
}
