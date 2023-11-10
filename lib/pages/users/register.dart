import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../widgets/button.dart';
import '../../colors.dart' as appColors;
import '../../helpers/WidgetHelper.dart';
import '../../services/service-user.dart';
import '../../classes/Exceptions/RequestException.dart';

class Register extends StatefulWidget
{
	@override
	_RegisterState	createState() => _RegisterState();
}

class _RegisterState extends State<Register>
{
	GlobalKey<FormState>		_keyForm 		= GlobalKey<FormState>();
	bool						_termsAgree 	= false;
	TextEditingController		_ctrlName		= TextEditingController();
	TextEditingController		_ctrlEmail		= TextEditingController();
	TextEditingController		_ctrlPass		= TextEditingController();
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
				padding: EdgeInsets.all(size.width * 0.067),
				child: ListView(
					children: [
						SizedBox(height: 15),
						Center(
							child: Image.asset('images/logo-text.png', fit: BoxFit.cover, height: 40),
						),
						SizedBox(height: 15),
						Text('¡Tu bienestar comienza aqui!', 
							textAlign: TextAlign.center,
							style: TextStyle(
								fontSize: 20, 
								fontWeight: FontWeight.bold,
								color: Color(0xff3c3c3b), /*appColors.mainColors['blue']*/
							)
						),
						SizedBox(height: 15),
						Text('Registrate para iniciar tu camino de desarrollo personal',
							textAlign: TextAlign.center,
							style: TextStyle(
								color: appColors.mainColors['gray'],
							),
						),
						SizedBox(height: 25),
						Container(
							/*
							padding: EdgeInsets.only(
								right: size.width * 0.067,
								left: size.width * 0.067,
							),
							*/
							child: this._getForm()
						),
					]
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
						controller: this._ctrlName,
						keyboardType: TextInputType.text,
						decoration: WidgetHelper.getTextFieldDecoration('Nombre y Apellido'),
						validator:(v)
						{
							if( v.isEmpty )
								return 'Debe ingresar su nombre';
						}
					),
					SizedBox(height: 10),
					TextFormField(
						controller: this._ctrlEmail,
						keyboardType: TextInputType.emailAddress,
						decoration: WidgetHelper.getTextFieldDecoration('Correo electrónico'),
						validator:(v)
						{
							if( v.isEmpty )
								return 'Debe ingresar su correo electronico';
						}
					),
					SizedBox(height: 10),
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
						validator: (v)
						{
							if( v.isEmpty )
								return 'Debe ingresar una contraseña';
						}
						
					),
					SizedBox(height: 10),
					TextFormField(
						keyboardType: TextInputType.text,
						decoration: WidgetHelper.getTextFieldDecoration('Código de invitación'),
					),
					SizedBox(height: 10),
					Row(
						children: [
							Checkbox(
								value: this._termsAgree,
								onChanged: (val)
								{
									this.setState(()
									{
										this._termsAgree = val;
									});
								}
							),
							SizedBox(width: 10),
							Expanded(
								child: InkWell(
									child: RichText(
										text: TextSpan(
											text: 'He leido y acepto los ',
											style: TextStyle(color: appColors.mainColors['gray']),
											children: [
												TextSpan(
													text: 'Terminos y Condiciones y ',
													style: TextStyle(color: appColors.mainColors['blue']),
													recognizer: TapGestureRecognizer()..onTap = ()
													{
														this._openUrl('https://hablaqui.cl/condiciones');
													}
													
												),
												TextSpan(
													text: 'la Politica de privacidad',
													style: TextStyle(color: appColors.mainColors['blue']),
													recognizer: TapGestureRecognizer()..onTap = ()
													{
														this._openUrl('https://hablaqui.cl/politicas');
													}
													
												)
											]
										),
									),
									//onTap: this._openConditions,
									
								)
							)
						]
					),
					/*
					TextButton(
						child: Text('¿Olvido la contraseña?', textAlign: TextAlign.left),
						style: ButtonStyle(
							alignment: Alignment.topLeft,
						),
						onPressed: (){}
					),
					*/
					SizedBox(height: 15),
					WidgetButton(
						text: 'Registrar',
						callback: this._doRegister,
						color: appColors.mainColors['blue'],
					),
					SizedBox(height: 25),
					Text('¿Ya tienes cuenta Hablaqui?', textAlign: TextAlign.center),
					SizedBox(height: 15),
					WidgetButton(
						text: 'Entrar',
						bordered: true,
						callback: ()
						{
							Navigator.of(this.context).pop();
						},
						color: appColors.mainColors['blue'],
					),
					SizedBox(height: 10),
					Text('2021 Hablaquí', textAlign: TextAlign.center),
				]
			)
		);
	}
	void _doRegister() async
	{
		if( !this._keyForm.currentState.validate() )
			return;
		try
		{
			if( !this._termsAgree )
				throw new Exception('Debe aceptar los terminos');
			var user = await ServiceUsers().register({
				'name': this._ctrlName.text.trim(),
				'email': this._ctrlEmail.text.trim(),
				'password': this._ctrlPass.text.trim(),
			});
			this._showSuccess();
		}
		on RequestException catch(e)
		{
			var data = e.getErrorMap();
			ScaffoldMessenger.of(this.context).showSnackBar(
				SnackBar(content: Text(data['error'] ?? 'Ocurrio un error en el proceso de registro'))
			);
		}
		catch(e)
		{
			print(e);
			ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('Ocurrio un error en el proceso de registro')));
		}
	}
	void _showSuccess()
	{
		showDialog(context: this.context, barrierDismissible: false,
			builder: (ctx)
			{
				return AlertDialog(
					title: Text('Registro completado'),
					content: SingleChildScrollView(
						child: ListBody(
							children: [
								Text('Tu registro se ha completado correctamente, ahora puedes iniciar sesión'),
								
							],
							
						)
					),
					actions: [
						TextButton(
							child: Text('Iniciar Sesión'),
							onPressed: () async
							{
								//Navigator.of(this.context).pushNamedAndRemoveUntil('/login', (_) => false);
								var user = await ServiceUsers().login(this._ctrlEmail.text.trim(), this._ctrlPass.text.trim());
								Navigator.of(this.context).pushNamedAndRemoveUntil('/home', (_) => false);
							}
						)
					]
				);
			}
		);
	}
	void _openUrl(url) async
	{
		//String url = 'https://hablaqui.cl/condiciones';
		if (await canLaunch(url)) 
		{
			await launch(url);
		} 
		else 
		{
			print('Could not launch $url');
		}
	}
}
