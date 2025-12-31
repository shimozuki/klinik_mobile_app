import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klinik/config/ApiConfig.dart';
import 'package:klinik/models/ReservasiModel.dart';

class ReservasiRepository {
  static String _baseUrl = ApiConfig.baseUrl;

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

  static Future<void> createReservasiSimple({
    required String token,
    required int jadwalId,
    int? layananId,
    String? keluhan,
  }) async {
    final Map<String, String> body = {
      'jadwal_id': jadwalId.toString(),
      'keluhan': keluhan ?? '',
    };

    if (layananId != null) {
      body['layanan_id'] = layananId.toString();
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/reservasi'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: body,
    );

    if (response.statusCode != 201) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Gagal membuat reservasi');
    }
  }
}
