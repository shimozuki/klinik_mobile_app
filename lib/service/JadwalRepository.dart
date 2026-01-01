import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klinik/config/ApiConfig.dart';
import 'package:klinik/models/JadwalModel.dart';

class JadwalDokterRepository {
  final String _baseUrl = ApiConfig.baseUrl;

  Future<List<DoctorSchedule>> getJadwalDokter(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/jadwal-dokter'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${token}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List list = json['data'];
      return list.map((e) => DoctorSchedule.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil jadwal dokter');
    }
  }

  Future<List<DoctorSchedule>> getByDay(String token, String hari) async {
    final data = await getJadwalDokter(token);
    return data.where((e) => e.hari == hari).toList();
  }
}
