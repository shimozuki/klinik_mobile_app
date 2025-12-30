import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/UserModel.dart';

class PasienRepository {
  final String baseUrl = 'http://192.168.1.5:8000/api';

  Future<UserModel> updateProfile({
    required String token,
    required UserModel user,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/pasien/profile'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(user.toUpdateProfileJson()),
          )
          .timeout(const Duration(seconds: 10)); // ⬅️ WAJIB

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      final Map<String, dynamic> body =
          response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 200) {
        return UserModel.fromJson(body['data']);
      } else {
        throw Exception(body['message'] ?? 'Gagal memperbarui profil');
      }
    } on TimeoutException {
      throw Exception('Koneksi ke server timeout');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
