import 'package:klinik/models/NotificationModel.dart';

class NotificationRepository {
  // Singleton
  static final NotificationRepository _instance =
      NotificationRepository._internal();
  factory NotificationRepository() => _instance;
  NotificationRepository._internal();

  final List<AppNotification> _notifications = [
    AppNotification(
      id: 'N001',
      title: 'Booking Berhasil',
      message:
          'Janji temu Anda dengan drg. Amanda Rodriguez telah dikonfirmasi.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      type: NotificationType.booking,
      isRead: false,
    ),
    AppNotification(
      id: 'N002',
      title: 'Pengingat Jadwal',
      message: 'Anda memiliki jadwal pemeriksaan hari ini pukul 10:00 WIB.',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      type: NotificationType.reminder,
      isRead: false,
    ),
    AppNotification(
      id: 'N003',
      title: 'Rekam Medis Tersedia',
      message: 'Rekam medis dari kunjungan terakhir Anda sudah dapat dilihat.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.medicalRecord,
      isRead: true,
    ),
    AppNotification(
      id: 'N004',
      title: 'Pembayaran Berhasil',
      message: 'Pembayaran sebesar Rp 450.000 telah berhasil.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.payment,
      isRead: true,
    ),
  ];

  /// Ambil semua notifikasi
  List<AppNotification> getAllNotifications() {
    return List.from(_notifications);
  }

  /// Ambil notifikasi belum dibaca
  List<AppNotification> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead).toList();
  }

  /// Tandai satu notifikasi sebagai dibaca
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
    }
  }

  /// Tandai semua sebagai dibaca
  void markAllAsRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
  }

  /// Tambah notifikasi baru
  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
  }

  /// Hapus notifikasi
  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
  }

  /// Total unread
  int getUnreadCount() {
    return _notifications.where((n) => !n.isRead).length;
  }
}
