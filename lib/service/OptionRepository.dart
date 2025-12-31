import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klinik/config/ApiConfig.dart';
import 'package:klinik/models/DokterOption.dart';
import 'package:klinik/models/LayananOption.dart';
import 'package:klinik/service/AuthLocalStorage.dart';

class OptionRepository {
  static String _baseUrl = ApiConfig.baseUrl;

  static Future<Map<String, String>> _authHeader() async {
    final token = await AuthLocalStorage.getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  static Future<List<DokterOptionModel>> getDokter() async {
    final headers = await _authHeader();

    final response = await http.get(
      Uri.parse('$_baseUrl/options/dokter'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List list = data['data'];
      return list.map((e) => DokterOptionModel.fromJson(e)).toList();
    } else {
      throw Exception(data['message'] ?? 'Gagal mengambil data dokter');
    }
  }

  static Future<List<LayananOptionModel>> getLayanan() async {
    final headers = await _authHeader();

    final response = await http.get(
      Uri.parse('$_baseUrl/options/layanan'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List list = data['data'];
      return list.map((e) => LayananOptionModel.fromJson(e)).toList();
    } else {
      throw Exception(data['message'] ?? 'Gagal mengambil data layanan');
    }
  }
}
