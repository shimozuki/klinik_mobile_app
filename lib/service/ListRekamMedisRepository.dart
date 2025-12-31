import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klinik/config/ApiConfig.dart';
import 'package:klinik/models/ListRekamMedisModel.dart';
import 'package:klinik/service/AuthLocalStorage.dart';

class ListRekamMedisRepository {
  final String _baseUrl = ApiConfig.baseUrl;

  Future<List<ListRekamMedisModel>> getByPasien() async {
    final token = await AuthLocalStorage.getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/rekam-medis/pasien'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ListRekamMedisModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil rekam medis');
    }
  }

  Future<List<ListRekamMedisModel>> getByReservasi(
    String nomorReservasi,
  ) async {
    final token = await AuthLocalStorage.getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/rekam-medis/reservasi/$nomorReservasi'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ListRekamMedisModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil rekam medis');
    }
  }
}
