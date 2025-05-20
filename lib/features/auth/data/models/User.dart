/// User model representing an authenticated user
class User
{
	final String? id;
	final String? name;
	final String? email;
	final String? state;
	final bool? google;
	final String? role;
	
	User({
		this.id,
		this.name,
		this.email,
		this.state,
		this.google,
		this.role,
	});
	
	factory User.fromMap(Map<String, dynamic> map)
	{
		return User(
			id: map['id']?.toString(),
			name: map['name']?.toString(),
			email: map['email']?.toString(),
			state: map['state']?.toString(),
			google: map['google'] as bool?,
			role: map['role']?.toString(),
		);
	}
	
	void loadData(Map<String, dynamic> map)
	{
		try
		{
			this.id		= map['id']?.toString();
			this.state	= map['state']?.toString();
			this.google	= map['google'] as bool?;
			this.role	= map['role']?.toString();
			this.name	= map['name']?.toString();
			this.email	= map['email']?.toString();
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
			'id': id,
			'name': name,
			'email': email,
			'state': state,
			'google': google,
			'role': role,
		};
	}
}
