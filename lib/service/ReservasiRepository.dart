import 'dart:convert';
import 'package:http/http.dart' as http;

class ReservasiRepository {
  static const String _baseUrl = 'http://192.168.41.140:8000/api';

  static Future<void> createReservasiSimple({
    required String token,
    required int jadwalId,
    String? keluhan,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/reservasi'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {'jadwal_id': jadwalId.toString(), 'keluhan': keluhan ?? ''},
    );

    if (response.statusCode != 201) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Gagal membuat reservasi');
    }
  }
}
