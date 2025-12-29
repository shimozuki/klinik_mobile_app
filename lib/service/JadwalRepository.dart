import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klinik/models/JadwalModel.dart';

class JadwalDokterRepository {
  final String baseUrl = 'http://192.168.41.39/api';

  /// 🔹 Ambil semua jadwal dokter
  Future<List<DoctorSchedule>> getJadwalDokter(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jadwal-dokter'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final List list = json['data'];

      return list.map((e) => DoctorSchedule.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil jadwal dokter');
    }
  }

  Future<List<DoctorSchedule>> getByDay(String token, String day) async {
    final data = await getJadwalDokter(token);
    return data.where((e) => e.day == day).toList();
  }
}
