import 'package:intl/intl.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderRole; // 'doctor' or 'patient'
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
  });

  String get formattedTime {
    return DateFormat('HH:mm').format(timestamp);
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(timestamp).inDays;

    if (difference == 0) {
      return 'Hari ini';
    } else if (difference == 1) {
      return 'Kemarin';
    } else if (difference < 7) {
      return DateFormat('EEEE', 'id_ID').format(timestamp);
    } else {
      return DateFormat('dd MMM yyyy', 'id_ID').format(timestamp);
    }
  }

  bool get isFromDoctor => senderRole == 'doctor';
}

class ChatRoom {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImageUrl;
  final String patientId;
  final String patientName;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final bool isOnline;
  final String status; // 'active', 'closed'
  final DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorImageUrl,
    required this.patientId,
    required this.patientName,
    this.lastMessage,
    this.unreadCount = 0,
    this.isOnline = false,
    this.status = 'active',
    required this.createdAt,
  });

  String get formattedLastMessageTime {
    if (lastMessage == null) return '';

    final now = DateTime.now();
    final messageTime = lastMessage!.timestamp;
    final difference = now.difference(messageTime);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} menit';
    } else if (difference.inDays < 1) {
      return DateFormat('HH:mm').format(messageTime);
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE', 'id_ID').format(messageTime);
    } else {
      return DateFormat('dd/MM/yy').format(messageTime);
    }
  }
}
