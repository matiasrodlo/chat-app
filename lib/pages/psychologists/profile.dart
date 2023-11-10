import 'package:flutter/material.dart';
import '../../classes/Specialist.dart';
import '../../colors.dart' as appColors;
import '../../widgets/button.dart';


class SpecialistProfile extends StatefulWidget
{
	final	Specialist	speccho;
	
	SpecialistProfile({@required this.speccho});
	
	@override
	_SpecialistProfileState	createState() => _SpecialistProfileState();
}

class _SpecialistProfileState extends State<SpecialistProfile>
{
	@override
	void initState()
	{
		super.initState();
	}
	Widget build(BuildContext context)
	{
		
		return Scaffold(
			appBar: AppBar(title: Text('Perfil del Psicólogo')),
			body: Container(
				padding: EdgeInsets.all(10),
				child: ListView(
					children: [
						Center(
							child: Container(
								width: 100,
								height: 100,
								child: CircleAvatar(
									backgroundImage: NetworkImage(this.widget.speccho.avatar),
								)
							)
						),
						SizedBox(height: 10),
						Text('Codigo: ${this.widget.speccho.code}', textAlign: TextAlign.center,
							style: TextStyle(fontWeight: FontWeight.bold, color: appColors.mainColors['blue'])
						),
						SizedBox(height: 10),
						this._buildFormation(),
						SizedBox(height: 10),
						this._buildSpecialties(),
						SizedBox(height: 20),
						WidgetButton(
							text: 'Agendar cita online',
							callback: this._bookNow,
							color: appColors.mainColors['blue'],
						),
					]
				)
			)
		);
	}
	Widget _buildFormation()
	{
		return Card(
			child: Container(
				padding: EdgeInsets.all(8),
				child: Column(
					children: [
						Text('Formación', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: appColors.mainColors['blue'])),
						SizedBox(height: 10),
						Text( this.widget.speccho.formation.map<String>( (f) => f).toList().join(', ') )
					]
				)
			)
		);
	}
	Widget _buildSpecialties()
	{
		return Card(
			child: Container(
				padding: EdgeInsets.all(8),
				child: Column(
					children: [
						Text('Especialidades', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: appColors.mainColors['blue'])),
						SizedBox(height: 10),
						Text( this.widget.speccho.specialties.map<String>( (f) => f).toList().join(', ') )
					]
				)
			)
		);
	}
	void _bookNow()
	{
	}
}
