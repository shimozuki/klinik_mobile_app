import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:klinik/models/UserModel.dart';

class AuthLocalStorage {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';
  static const _expiredAtKey = 'auth_expired_at';

  static Future<void> saveLogin({
    required String token,
    required UserModel user,
    required DateTime expiredAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user));
    await prefs.setString(_expiredAtKey, expiredAt.toIso8601String());
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson == null) return null;

    return UserModel.fromJson(jsonDecode(userJson));
  }

  static Future<DateTime?> getExpiredAt() async {
    final prefs = await SharedPreferences.getInstance();
    final expiredString = prefs.getString(_expiredAtKey);

    if (expiredString == null) return null;

    return DateTime.parse(expiredString);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_expiredAtKey);
  }
}
