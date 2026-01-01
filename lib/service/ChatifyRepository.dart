import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klinik/config/ApiConfig.dart';

class ChatifyRepository {
  final String baseUrl = 'http://192.168.1.5:8000/api';
  final String _baseUrl = 'http://192.168.1.5:8000/chatify/api';

  Map<String, String> _headers(String token) => {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Future<void> sendMessage({
    required String token,
    required int toId,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/sendMessage'),
      headers: _headers(token),
      body: {
        'id': toId.toString(), // ✅ WAJIB "id"
        'type': 'user', // ✅ WAJIB
        'message': message, // ✅ WAJIB "message"
      },
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  Future<List<dynamic>> fetchMessages({
    required String token,
    required int withUserId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/fetchMessagesMobile'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {'id': withUserId.toString()},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print('message $body');
      return body['messages'] as List<dynamic>;
    } else {
      throw jsonDecode(response.body);
    }
  }

  Future<List<dynamic>> getContacts(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/chat/contacts'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (res.statusCode != 200) {
      throw throw json.decode(res.body);
    }

    final body = jsonDecode(res.body);
    return body['contacts'];
  }
}
