import 'package:flutter/material.dart';
import 'package:klinik/page/LoginPage.dart';
import 'package:klinik/page/HomePage.dart';
import 'package:klinik/models/UserModel.dart';
import 'package:klinik/service/AuthLocalStorage.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<(UserModel, String)?> _checkAuth() async {
    final token = await AuthLocalStorage.getToken();
    final user = await AuthLocalStorage.getUser();
    final expiredAt = await AuthLocalStorage.getExpiredAt();

    if (token == null || user == null || expiredAt == null) {
      return null;
    }

    // cek token expired
    if (DateTime.now().isAfter(expiredAt)) {
      await AuthLocalStorage.clear();
      return null;
    }

    return (user, token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(UserModel, String)?>(
      future: _checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const LoginPage();
        }

        final user = snapshot.data!.$1;
        final token = snapshot.data!.$2;

        return HomePage(user: user, token: token);
      },
    );
  }
}
