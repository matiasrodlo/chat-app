import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ChatMessage
{
	String?		id;
	String?		content;
	String?		sentBy;
	DateTime?	sentAt;
	bool?		read;
	DateTime?	updatedAt;
	DateTime?	createdAt;
	
	String get date
	{
		if (createdAt == null) return '';
		var format = DateFormat('MMM d, K:m aaa');
		return format.format(this.createdAt!);
	}
	
	ChatMessage({
		this.id,
		this.content,
		this.sentBy,
		this.sentAt,
		this.read,
		this.updatedAt,
		this.createdAt,
	});
	
	ChatMessage.fromMap(Map<String, dynamic> map)
	{
		this.id			= map['id']?.toString();
		this.content	= map['content']?.toString();
		this.sentBy		= map['sentBy']?.toString();
		this.sentAt		= map['sentAt'] != null ? DateTime.parse(map['sentAt']) : null;
		this.read		= map['read'] as bool?;
		this.updatedAt	= map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null;
		this.createdAt	= map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null;
	}

	void loadData(Map data)
	{
		try
		{
			this.id			= data['_id'];
			this.content	= data['content'];
			this.sentBy		= data['sentBy'];
			this.sentAt		= DateTime.parse(data['sentAt']);
			this.read		= data['read'];
			this.updatedAt	= DateTime.parse(data['updatedAt']);
			this.createdAt	= DateTime.parse(data['createdAt']);
		}
		catch(e)
		{
			print('CHAT MESSAGE ERROR LOADING DATA');
			print(e);
		}
	}

	Map<String, dynamic> toMap() {
		return {
			'id': id,
			'content': content,
			'sentBy': sentBy,
			'sentAt': sentAt?.toIso8601String(),
			'read': read,
			'updatedAt': updatedAt?.toIso8601String(),
			'createdAt': createdAt?.toIso8601String(),
		};
	}
}
