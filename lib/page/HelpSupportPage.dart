import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ================= HEADER (FULL WIDTH) =================
          Container(
            width: double.infinity, // 🔥 WAJIB
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bantuan & Dukungan',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Kami siap membantu Anda',
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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              children: const [
                _HelpCard(
                  icon: Icons.help_outline_rounded,
                  title: 'Pertanyaan Umum',
                  subtitle:
                      'Jawaban atas pertanyaan yang sering ditanyakan pengguna.',
                ),
                _HelpCard(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Hubungi Dukungan',
                  subtitle: 'Hubungi tim kami melalui WhatsApp atau email.',
                ),
                _HelpCard(
                  icon: Icons.report_problem_outlined,
                  title: 'Laporkan Masalah',
                  subtitle: 'Laporkan kendala atau bug yang Anda temui.',
                ),
                _HelpCard(
                  icon: Icons.info_outline_rounded,
                  title: 'Tentang Aplikasi',
                  subtitle: 'Informasi versi aplikasi dan pengembang.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= CARD COMPONENT =================
class _HelpCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _HelpCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A202C),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {
          // TODO: navigation / WhatsApp / Email
        },
      ),
    );
  }
}
