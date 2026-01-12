import 'package:flutter/material.dart';
import 'package:klinik/models/UserModel.dart';
import 'package:klinik/page/LandingPage.dart';
import 'package:klinik/page/LoginPage.dart';
import 'package:klinik/page/HomePage.dart';
import 'package:klinik/service/AuthLocalStorage.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  Future<void> _initAuth() async {
    final auth = await _checkAuth();

    if (!mounted) return;

    if (auth == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PublicLandingPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(user: auth.$1, token: auth.$2),
        ),
      );
    }
  }

  Future<(UserModel, String)?> _checkAuth() async {
    final token = await AuthLocalStorage.getToken();
    final user = await AuthLocalStorage.getUser();
    final expiredAt = await AuthLocalStorage.getExpiredAt();

    if (token == null || user == null || expiredAt == null) {
      return null;
    }

    if (expiredAt.isBefore(DateTime.now())) {
      await AuthLocalStorage.clear();
      return null;
    }

    return (user, token);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
