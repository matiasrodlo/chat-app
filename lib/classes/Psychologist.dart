class Specialist
{
	String			id;
	String			name;
	String			lastName;
	String			code;
	String			personalDescription;
	String			professionalDescription;
	String			email;
	String			gender;
	String			avatar;
	List<dynamic>	languages		= [];
	List<dynamic>	experience		= [];
	List<dynamic>	specialties	= [];
	List<dynamic>	formation		= [];
	List<dynamic>	models			= [];
	
	String get fullName => this.name + ' ' + this.lastName;
	
	Specialist();
	
	Specialist.fromMap(Map data)
	{
		this.loadData(data);
	}
	void loadData(Map data)
	{
		if( data == null )
			return;
		try
		{
			this.id							= data['_id'];
			this.name						= data['name'];
			this.lastName					= data['lastName'];
			this.code						= data['code'];
			this.personalDescription		= data['personalDesription'];
			this.professionalDescription	= data['professionalDescription'];
			this.email						= data['email'];
			this.gender						= data['gender'];
			this.avatar						= data['avatar'];
			this.languages					= data['languages'];
			this.experience					= data['experience'];
			this.specialties				= data['specialties'];
			this.formation					= data['formation'];
			this.models						= data['models'];
		}
		catch(e)
		{
			print('SPECIALIST LOAD DATA ERROR');
			print(e);
		}
	}
}
