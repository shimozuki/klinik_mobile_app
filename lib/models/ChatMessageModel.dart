class ChatMessageModel {
  final String id;
  final String body;
  final bool isSender;
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.body,
    required this.isSender,
    required this.createdAt,
  });

  factory ChatMessageModel.fromChatify(
    Map<String, dynamic> json,
    int myUserId,
  ) {
    return ChatMessageModel(
      id: json['id'].toString(),
      body: json['body'] ?? '',
      isSender: json['from_id'] == myUserId,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get formattedDate =>
      '${createdAt.day}/${createdAt.month}/${createdAt.year}';
}
