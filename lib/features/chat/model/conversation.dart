class Conversation {
  final String id;
  final String userOneId;
  final String userTwoId;
  final String propertyId;
  final String? lastMessageText;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final DateTime createdAt;

  Conversation({
    required this.id,
    required this.userOneId,
    required this.userTwoId,
    required this.propertyId,
    this.lastMessageText,
    this.lastMessageAt,
    required this.unreadCount,
    required this.createdAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      userOneId: json['user_one_id'] as String,
      userTwoId: json['user_two_id'] as String,
      propertyId: json['property_id'] as String,
      lastMessageText: json['last_message_text'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      unreadCount: json['unread_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_one_id': userOneId,
      'user_two_id': userTwoId,
      'property_id': propertyId,
      'last_message_text': lastMessageText,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'unread_count': unreadCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}