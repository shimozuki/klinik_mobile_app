import 'package:klinik/config/ApiConfig.dart';
import 'package:klinik/models/AppointmentModel.dart';
import 'package:klinik/models/ReservasiModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AppointmentData {
  static String _baseUrl = ApiConfig.baseUrl;

  static List<Appointment> upcomingAppointments = [];
  static List<Appointment> completedAppointments = [];
  static List<Appointment> cancelledAppointments = [];

  Future<List<ReservasiModel>> getReservasi(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/reservasi'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json['data'] as List)
          .map((e) => ReservasiModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Gagal mengambil data reservasi');
    }
  }

  // ================== CANCEL RESERVASI ==================
  static Future<void> cancelReservasi({
    required String token,
    required int reservasiId,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/reservasi/$reservasiId/cancel'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    print(token);

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Gagal membatalkan reservasi');
    }
  }
}
