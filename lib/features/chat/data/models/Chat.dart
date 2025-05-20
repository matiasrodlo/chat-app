import '../../../../features/specialist/data/models/specialist.dart';

/// Chat model representing a conversation with a specialist
class Chat
{
	final String? id;
	final List<dynamic>? reports;
	final DateTime? updatedAt;
	final DateTime? createdAt;
	final Specialist? specialist;
	final String? lastMessage;
	final DateTime? lastMessageTime;
	final bool? unread;
	
	Chat({
		this.id,
		this.reports,
		this.updatedAt,
		this.createdAt,
		this.specialist,
		this.lastMessage,
		this.lastMessageTime,
		this.unread,
	});
	
	factory Chat.fromMap(Map<String, dynamic> map)
	{
		return Chat(
			id: map['id']?.toString(),
			reports: map['reports'],
			updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
			createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
			specialist: map['specialist'] != null ? Specialist.fromMap(map['specialist']) : null,
			lastMessage: map['lastMessage']?.toString(),
			lastMessageTime: map['lastMessageTime'] != null ? DateTime.parse(map['lastMessageTime']) : null,
			unread: map['unread'] as bool?,
		);
	}
	
	void loadData(Map<String, dynamic> data)
	{
		try
		{
			this.id			= data['_id']?.toString();
			this.reports	= data['reports'];
			this.updatedAt	= DateTime.parse(data['updatedAt']);
			this.createdAt	= DateTime.parse(data['createdAt']);
			this.specialist = data['specialist'] != null ? Specialist.fromMap(data['specialist']) : null;
			this.lastMessage = data['lastMessage']?.toString();
			this.lastMessageTime = data['lastMessageTime'] != null ? DateTime.parse(data['lastMessageTime']) : null;
			this.unread = data['unread'] as bool?;
		}
		catch(e)
		{
			print('ERROR trying to load chat data');
			print(e);
		}
	}
	
	Map<String, dynamic> toMap()
	{
		return {
			'_id': id,
			'reports': reports,
			'updatedAt': updatedAt?.toIso8601String(),
			'createdAt': createdAt?.toIso8601String(),
			'specialist': specialist?.toMap(),
			'lastMessage': lastMessage,
			'lastMessageTime': lastMessageTime?.toIso8601String(),
			'unread': unread,
		};
	}
}
