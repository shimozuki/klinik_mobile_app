import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klinik/config/ApiConfig.dart';
import '../models/LayananModel.dart';

class LayananRepository {
  final String baseUrl = ApiConfig.baseUrl;

  Future<List<LayananModel>> getLayanan() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/layanan'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Status ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List data = body['data'] ?? [];

      return data.map((e) => LayananModel.fromJson(e)).toList();
    } catch (e) {
      print('ERROR getLayanan: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDokter() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dokter'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Status ${response.statusCode}');
      }

      final body = jsonDecode(response.body);

      if (body['success'] != true || body['data'] == null) {
        return [];
      }

      final List data = body['data'];

      return data
          .map((e) {
            return {'id': e['id'] ?? 0, 'nama': e['name'] ?? ''};
          })
          .where((e) => e['id'] != 0)
          .toList();
    } catch (e) {
      print('ERROR getDokter: $e');
      return [];
    }
  }
}
