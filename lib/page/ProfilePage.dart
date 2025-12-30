import 'package:flutter/material.dart';
import 'package:klinik/models/UserModel.dart';
import 'package:klinik/page/EditProfilePage.dart';
import 'package:klinik/page/HelpSupportPage.dart';
import 'package:klinik/page/ListRekamMedis.dart';
import 'package:klinik/page/NotificationPage.dart';
import 'package:klinik/page/PrivacyPolicyPage.dart';
import 'package:klinik/service/RekamMedisRepository.dart';
import 'package:klinik/service/AuthLocalStorage.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  final String token;

  const ProfilePage({Key? key, required this.user, required this.token})
    : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel user;
  late String token;

  final RekamMedisRepository _rekamMedisRepository = RekamMedisRepository();

  @override
  void initState() {
    super.initState();
    user = widget.user;
    token = widget.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildMenu(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Profil Saya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.settings, color: Colors.white),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Pasien',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= MENU =================
  Widget _buildMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profil',
            subtitle: 'Kelola informasi pribadi Anda',
            onTap: _goToEditProfile,
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.medical_information_outlined,
            title: 'Rekam Medis',
            subtitle: 'Lihat riwayat rekam medis',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => MedicalRecordListPage(
                        records: _rekamMedisRepository.getAllMedicalRecords(),
                      ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Notifikasi',
            subtitle: 'Atur preferensi notifikasi',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationPage()),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Bantuan & Dukungan',
            subtitle: 'Pusat bantuan dan FAQ',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpSupportPage()),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Kebijakan Privasi',
            subtitle: 'Baca kebijakan privasi kami',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildLogoutButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ================= ACTIONS =================
  Future<void> _goToEditProfile() async {
    final updatedUser = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilPage(user: user, token: token),
      ),
    );

    if (updatedUser != null) {
      setState(() {
        user = updatedUser;
      });

      final expiredAt =
          await AuthLocalStorage.getExpiredAt() ??
          DateTime.now().add(const Duration(days: 1));

      await AuthLocalStorage.saveLogin(
        token: token,
        user: updatedUser,
        expiredAt: expiredAt,
      );
    }
  }

  // ================= WIDGET HELPERS =================
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF4A90E2)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await AuthLocalStorage.clear();
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Keluar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
