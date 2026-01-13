import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:klinik/config/ApiConfig.dart';
import 'package:klinik/models/NotificationModel.dart';
import 'package:klinik/service/AuthLocalStorage.dart';

class NotificationRepository {
  // ================= SINGLETON =================
  static final NotificationRepository _instance =
      NotificationRepository._internal();
  factory NotificationRepository() => _instance;
  NotificationRepository._internal();

  // ================= CONFIG =================
  final String _baseUrl = ApiConfig.baseUrl;

  // ================= STATE =================
  final ValueNotifier<int> unreadCountNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);

  List<AppNotification> _notifications = [];

  // ================= FETCH =================
  Future<List<AppNotification>> fetchNotifications() async {
    final token = await AuthLocalStorage.getToken();
    if (token == null) return [];

    isLoadingNotifier.value = true;

    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode != 200) {
        throw Exception('Gagal mengambil notifikasi');
      }

      final List data = json.decode(res.body);

      _notifications = data.map((e) => AppNotification.fromApi(e)).toList();

      // 🔥 KUNCI REALTIME
      unreadCountNotifier.value = _notifications.where((n) => !n.isRead).length;

      return List.from(_notifications);
    } finally {
      isLoadingNotifier.value = false;
    }
  }

  // ================= GETTERS =================
  List<AppNotification> getAllNotifications() =>
      List.unmodifiable(_notifications);

  List<AppNotification> getUnreadNotifications() =>
      _notifications.where((n) => !n.isRead).toList();

  int getUnreadCount() => unreadCountNotifier.value;

  // ================= ACTIONS =================
  Future<void> markAsRead(String id) async {
    final token = await AuthLocalStorage.getToken();
    if (token == null) return;

    await http.put(
      Uri.parse('$_baseUrl/notifications/$id/read'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;

      // 🔥 update badge
      unreadCountNotifier.value = _notifications.where((n) => !n.isRead).length;
    }
  }

  Future<void> markAllAsRead() async {
    for (final n in _notifications.where((n) => !n.isRead)) {
      await markAsRead(n.id);
    }

    unreadCountNotifier.value = 0;
  }

  Future<void> deleteNotification(String id) async {
    final token = await AuthLocalStorage.getToken();
    if (token == null) return;

    await http.delete(
      Uri.parse('$_baseUrl/notifications/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    _notifications.removeWhere((n) => n.id == id);

    unreadCountNotifier.value = _notifications.where((n) => !n.isRead).length;
  }
}
