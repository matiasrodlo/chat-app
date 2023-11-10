import 'package:flutter/material.dart';
import '../../classes/Specialist.dart';
import '../../services/service-hablaqui.dart';
import 'profile.dart';
import '../../helpers/WidgetHelper.dart';

class SearchSpecialists extends StatefulWidget
{
	@override
	_SearchSpecialists	createState() => _SearchSpecialists();
}

class _SearchSpecialists extends State<SearchSpecialists>
{
	List<Specialist>		_items = [];
	
	@override
	void initState()
	{
		super.initState();
	}
	@override
	Widget build(BuildContext context)
	{
		return Scaffold(
			appBar: AppBar(title: Text('Busqueda de Especialista')),
			body: Container(
				padding: EdgeInsets.all(10),
				child: Column(
					children: [
						TextFormField(
							decoration: WidgetHelper.getTextFieldDecoration('Buscar', Colors.grey.withOpacity(0.6)),
						),
						SizedBox(height: 10),
						Expanded(
							child: StreamBuilder(
								stream: this._getSpecialists(),
								builder: (ctx, snapshot)
								{
									if( !snapshot.hasData )
										return Center(child: CircularProgressIndicator());
										
									if( snapshot.data.length <= 0 )
										return Center(child: Text('No se encontraron resultados'));
										
									return ListView.builder(
										itemCount: this._items.length,
										itemBuilder: (_ctx, index)
										{
											return this._buildItem(this._items[index]);
										}
									);
								}
							)
						)
					]
				)
			),
		);
	}
	Stream<List> _getSpecialists() async*
	{
		var items = await ServiceHablaqui().getSpecialists();
		
		this._items.addAll( items );
		
		yield this._items;
	}
	Widget _buildItem(Specialist speccho)
	{
		return Card(
			elevation: 0,
			child: Container(
				child: ListTile(
					leading: CircleAvatar(
						backgroundImage: NetworkImage(speccho.avatar),
						backgroundColor: Colors.grey,
					),
					title: Text(speccho.fullName),
					subtitle: Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							Text('Especialista - Activo')
						]
					),
					//trailing: Image.network(speccho.avatar)
					onTap: ()
					{
						Navigator.push(this.context, MaterialPageRoute(builder: (_) => SpecialistProfile(speccho: speccho)));
					}
				)
			)
		);
	}
}
