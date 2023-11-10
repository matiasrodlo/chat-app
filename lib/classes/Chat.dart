import 'Specialist.dart';

class Chat
{
	String			id;
	List			reports;
	DateTime		updatedAt;
	DateTime		createdAt;
	Specialist	specialist;
	
	Chat();
	
	Chat.fromMap(Map data)
	{
		this.loadData(data);
	}
	void loadData(Map data)
	{
		try
		{
			this.id				= data['_id'];
			this.reports		= data['reports'];
			this.specialist	= new Specialist.fromMap(data['specialist']);
			this.updatedAt		= DateTime.parse(data['createdAt']);
			this.createdAt		= DateTime.parse(data['updatedAt']);
		}
		catch(e)
		{
			print('ERROR LOADING CHAT DATA');
			print(e);
		}
	}
}
