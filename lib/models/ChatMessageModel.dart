import 'package:klinik/models/AttachmentModel.dart';

class ChatMessageModel {
  final String id;
  final String body;
  final bool isSender;
  final DateTime createdAt;
  final String type; // text | image | file
  final AttachmentModel? attachment;

  ChatMessageModel({
    required this.id,
    required this.body,
    required this.isSender,
    required this.createdAt,
    this.type = 'text',
    this.attachment,
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
      type: json['type'] ?? 'text',
      attachment:
          json['attachment'] != null
              ? AttachmentModel.fromJson(json['attachment'])
              : null,
    );
  }

  String get formattedDate =>
      '${createdAt.day}/${createdAt.month}/${createdAt.year}';
}
