import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ================= HEADER (FULL WIDTH) =================
          Container(
            width: double.infinity, // 🔥 PENTING
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
              ),
            ),
            child: SafeArea(
              bottom: false, // 🔥 biar tidak turun
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kebijakan Privasi',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Perlindungan data & privasi Anda',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ================= CONTENT =================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  '''
Kami menghargai privasi Anda.

Aplikasi Klinik mengumpulkan informasi pribadi seperti nama, kontak, dan data medis hanya untuk keperluan layanan kesehatan.

Data Anda disimpan secara aman dan tidak dibagikan kepada pihak ketiga tanpa persetujuan, kecuali diwajibkan oleh hukum.

Kami menggunakan standar keamanan yang sesuai untuk melindungi data Anda.

Dengan menggunakan aplikasi ini, Anda menyetujui Kebijakan Privasi ini.
                  ''',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
