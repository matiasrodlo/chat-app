class User
{
	String	id;
	bool	state;
	bool	google;
	String	role;
	String	name;
	String	email;
	
	User({this.id, this.state, this.google, this.role, this.name, this.email});
	
	User.fromMap(Map data)
	{
		this.loadData(data);
	}
	void loadData(Map data)
	{
		try
		{
			this.id		= data['_id'];
			this.state	= data['state'];
			this.google	= data['google'];
			this.role	= data['role'];
			this.name	= data['name'];
			this.email	= data['email'];
		}
		catch(e)
		{
			print('ERROR trying to load user data');
			print(e);
		}
	}
	Map<String, dynamic> toMap()
	{
		return {
			'_id': this.id,
			'state': this.state,
			'google': this.google,
			'role': this.role,
			'name': this.name,
			'email': this.email,
		};
	}
}
