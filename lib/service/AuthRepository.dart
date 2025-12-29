import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klinik/models/UserModel.dart';

class AuthRepository {
  static const String _baseUrl = 'http://192.168.41.39:8000/api';

  /// LOGIN
  Future<(String, UserModel)> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final String token = data['token'] as String;
      final UserModel user = UserModel.fromJson(data['user']);

      return (token, user);
    } else {
      throw Exception(data['message'] ?? 'Login gagal');
    }
  }

  /// REGISTER PASIEN
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String tanggalLahir,
    required String jenisKelamin,
    required String alamat,
    required String telepon,
    String? nik,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Accept': 'application/json'},
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'tanggal_lahir': tanggalLahir,
        'jenis_kelamin': jenisKelamin,
        'alamat': alamat,
        'telepon': telepon,
        'nik': nik ?? '',
      },
    );

    final data = json.decode(response.body);

    if (response.statusCode != 201) {
      throw Exception(data['message'] ?? 'Registrasi gagal');
    }
  }

  /// GET USER PROFILE
  Future<UserModel> me(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/me'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Token tidak valid');
    }
  }

  /// LOGOUT
  Future<void> logout(String token) async {
    await http.post(
      Uri.parse('$_baseUrl/logout'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }
}
