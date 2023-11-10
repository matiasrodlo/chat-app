import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/button.dart';
import '../../colors.dart' as appColors;
import '../../helpers/WidgetHelper.dart';
import '../../services/service-user.dart';
import '../../classes/User.dart';

class Login extends StatefulWidget
{
	
	@override
	_LoginState	createState() => _LoginState();
}
class _LoginState extends State<Login>
{
	GlobalKey<FormState>		_keyForm 		= GlobalKey<FormState>();
	TextEditingController		_ctrlEmail		= TextEditingController();
	TextEditingController		_ctrlPass		= TextEditingController();
	bool						_processing		= false;
	bool						_showPass		= false;
	
	@override
	void initState()
	{
		super.initState();
	}
	@override
	Widget build(BuildContext context)
	{
		var size = MediaQuery.of(context).size;
		
		return Scaffold(
			appBar: AppBar(
				title: Text(''), backgroundColor: Colors.white, elevation: 0,
				actionsIconTheme: IconThemeData(
					color: Theme.of(context).primaryColor,
				),
				iconTheme: IconThemeData(
					color: Theme.of(context).primaryColor,
				)
			),
			body: Container(
				color: Colors.white,
				padding: EdgeInsets.all(size.width * 0.078),
				child: Center(
					child: ListView(
					shrinkWrap: true,
					children: [
						//SizedBox(height: 15),
						Center(
							child: Image.asset('images/logo-text.png', fit: BoxFit.cover, height: 40),
						),
						SizedBox(height: 15),
						Text('¡Que gusto verte nuevamente!', 
							textAlign: TextAlign.center,
							style: TextStyle(fontSize: 20,
								fontWeight: FontWeight.bold,
								color: Color(0xff3c3c3b), //appColors.mainColors['blue']
							)
						),
						SizedBox(height: 15),
						Text('Ingresa y continua tu viaje de desarrollo personal ahora mismo',
							textAlign: TextAlign.center,
							style: TextStyle(
								fontSize: 12,
								color: appColors.mainColors['gray'],
							),
						),
						SizedBox(height: 25),
						this._getForm(),
										
					]
				)
				)
			)
		);
	}
	Widget _getForm()
	{
		return Form(
			key: this._keyForm,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children:[
					TextFormField(
						controller: this._ctrlEmail,
						keyboardType: TextInputType.emailAddress,
						decoration: WidgetHelper.getTextFieldDecoration('Correo electrónico'),
						validator:(v)
						{
							if( v.isEmpty )
								return 'Debe ingresar su email';
						}
					),
					SizedBox(height: 19),
					TextFormField(
						controller: this._ctrlPass,
						keyboardType: TextInputType.text,
						obscureText: !this._showPass,
						decoration: WidgetHelper.getTextFieldDecoration('Contraseña').copyWith(
							suffixIcon: InkWell(
								child: Container(
									//color: Colors.red,
									padding: EdgeInsets.all(10),
									child: FaIcon(
										this._showPass ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
										color: Colors.grey,
										
									)
								),
								onTap: ()
								{
									this.setState(()
									{
										this._showPass = !this._showPass;
									});
								}
							),
						),
						validator:(v)
						{
							if( v.isEmpty )
								return 'Debe ingresar su contraseña';
						}
					),
					SizedBox(height: 19),
					TextButton(
						child: Text('¿Olvidó la contraseña?', textAlign: TextAlign.left),
						style: ButtonStyle(
							alignment: Alignment.topLeft,
						),
						onPressed: (){}
					),
					SizedBox(height: 15),
					if( !this._processing )
					WidgetButton(
						text: 'Entrar',
						callback: this._doLogin,
						color: appColors.mainColors['blue'],
					),
					if( this._processing )
					Center(child: CircularProgressIndicator()),
					SizedBox(height: 25),
					
					Text('¿No eres parte de Hablaqui?', textAlign: TextAlign.center),
					SizedBox(height: 10),
					WidgetButton(
						text: 'Crear una cuenta',
						bordered: true,
						callback: ()
						{
							Navigator.of(this.context).pushNamed('/register');
						},
						color: appColors.mainColors['blue'],
					),
					SizedBox(height: 35),
					TextButton(
						child: Text('Aviso de privacidad y condiciones de uso', textAlign: TextAlign.left),
						onPressed: () async
						{
							String url = 'https://hablaqui.cl/politicas';
							if (await canLaunch(url)) 
							{
								await launch(url);
							} 
							else 
							{
								print('Could not launch $url');
							}
						}
					),
					SizedBox(height: 1),
					Text('2022 Hablaqui', textAlign: TextAlign.center),
				]
			)
		);
	}
	void _doLogin() async
	{
		if( !this._keyForm.currentState.validate() )
			return;
		try
		{
			this.setState(()
			{
				this._processing = true;
			});
			var user = await ServiceUsers().login(this._ctrlEmail.text.trim(), this._ctrlPass.text.trim());
			print(user);
			Navigator.of(this.context).pushNamedAndRemoveUntil('/home', (_) => false);
		}
		catch(e)
		{
			this.setState(()
			{
				this._processing = false;
			});
			print(e);
			ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('Correo o contraeña incorrecta')));
		}
	}
}
