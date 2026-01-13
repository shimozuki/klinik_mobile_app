import 'package:intl/intl.dart';

enum NotificationType { booking, reminder, medicalRecord, payment, other }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final NotificationType type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.type,
    required this.isRead,
  });

  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) {
      return 'Baru saja';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else {
      return DateFormat('dd MMM yyyy, HH:mm').format(createdAt);
    }
  }

  factory AppNotification.fromApi(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return AppNotification(
      id: json['id'],
      title: data['title'] ?? 'Notifikasi',
      message: data['body'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['read_at'] != null,
      type: _mapType(data['type']),
    );
  }

  static NotificationType _mapType(String? type) {
    switch (type) {
      case 'reservasi':
        return NotificationType.booking;
      case 'payment':
        return NotificationType.payment;
      default:
        return NotificationType.other;
    }
  }
}
