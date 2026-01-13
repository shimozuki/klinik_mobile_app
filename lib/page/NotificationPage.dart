import 'package:flutter/material.dart';
import 'package:klinik/models/NotificationModel.dart';
import 'package:klinik/service/NotificationRepository.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationRepository _repository = NotificationRepository();
  late List<AppNotification> _notifications;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() async {
    setState(() => _isLoading = true);

    try {
      final data = await _repository.fetchNotifications();
      setState(() {
        _notifications = data;
      });
    } catch (e) {
      debugPrint('Error load notif: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _notifications.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                      onRefresh: () async => _loadNotifications(),
                      color: const Color(0xFF4A90E2),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final item = _notifications[index];
                          return _buildNotificationItem(item);
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notifikasi',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Informasi terbaru untuk Anda',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     _buildHeaderAction(
                  //       icon: Icons.done_all_rounded,
                  //       onTap: () async {
                  //         await _repository.markAllAsRead();
                  //         _loadNotifications();
                  //       },
                  //     ),
                  //     const SizedBox(width: 12),
                  //     _buildHeaderAction(icon: Icons.notifications_rounded),
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderAction({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }

  // ================= ITEM =================
  Widget _buildNotificationItem(AppNotification notification) {
    final color = _getColor(notification.type);
    final icon = _getIcon(notification.type);

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) async {
        await _repository.deleteNotification(notification.id);
        _loadNotifications();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            if (!notification.isRead) {
              await _repository.markAsRead(notification.id);
              _loadNotifications();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.message,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification.formattedTime,
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================
  Widget _buildEmptyState() {
    return const Center(
      child: Text('Tidak ada notifikasi', style: TextStyle(color: Colors.grey)),
    );
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Icons.calendar_today_rounded;
      case NotificationType.reminder:
        return Icons.alarm_rounded;
      case NotificationType.medicalRecord:
        return Icons.folder_open_rounded;
      case NotificationType.payment:
        return Icons.payment_rounded;
      case NotificationType.other:
        return Icons.settings_rounded;
    }
  }

  Color _getColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return const Color(0xFF4A90E2);
      case NotificationType.reminder:
        return const Color(0xFFFF9800);
      case NotificationType.medicalRecord:
        return const Color(0xFF4CAF50);
      case NotificationType.payment:
        return const Color(0xFF9C27B0);
      case NotificationType.other:
        return const Color(0xFF607D8B);
    }
  }
}
