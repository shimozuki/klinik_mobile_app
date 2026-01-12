import 'package:flutter/material.dart';
import 'package:klinik/models/JadwalModel.dart';
import 'package:klinik/models/LayananModel.dart';
import 'package:klinik/page/RegisterPage.dart';
import 'package:klinik/service/JadwalRepository.dart';
import 'package:klinik/service/LayananRepository.dart';
import '../page/LoginPage.dart';

class PublicLandingPage extends StatefulWidget {
  const PublicLandingPage({super.key});

  @override
  State<PublicLandingPage> createState() => _PublicLandingPageState();
}

class _PublicLandingPageState extends State<PublicLandingPage> {
  final LayananRepository _layananRepo = LayananRepository();
  late Future<List<LayananModel>> _layananFuture;
  late Future<List<Map<String, dynamic>>> _dokterFuture;

  final JadwalDokterRepository _jadwalRepo = JadwalDokterRepository();
  late Future<List<DoctorSchedule>> _jadwalFuture;

  @override
  void initState() {
    super.initState();
    _layananFuture = _layananRepo.getLayanan();
    _jadwalFuture = _jadwalRepo.getJadwalPublik();
    _dokterFuture = _layananRepo.getDokter();
  }

  final List<Color> _bannerColors = const [
    Color(0xFF4A90E2),
    Color(0xFF50C9C3),
    Color(0xFFFF6B6B),
    Color(0xFFFFBE0B),
    Color(0xFF6C5CE7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              // _buildSearchBar(),
              _buildBanner(),
              _buildSectionTitle('Jadwal Dokter'),
              _buildJadwalChips(),
              _buildSectionTitle('Dokter Kami'),
              _buildDoctorCard(),
              const SizedBox(height: 24),
              _buildAuthButtons(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Klinik Sehat Sentosa',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Pelayanan kesehatan profesional & terpercaya',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ================= SEARCH BAR =================
  // Widget _buildSearchBar() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: TextField(
  //       enabled: false,
  //       decoration: InputDecoration(
  //         hintText: 'Cari dokter',
  //         prefixIcon: const Icon(Icons.search),
  //         filled: true,
  //         fillColor: const Color.fromARGB(255, 214, 214, 214),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(14),
  //           borderSide: BorderSide.none,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // ================= BANNER LAYANAN =================
  Widget _buildBanner() {
    return FutureBuilder<List<LayananModel>>(
      future: _layananFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Layanan belum tersedia'),
          );
        }

        return SizedBox(
          height: 170,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final layanan = snapshot.data![index];
              final color = _bannerColors[index % _bannerColors.length];

              return _layananBannerItem(layanan.nama, color);
            },
          ),
        );
      },
    );
  }

  Widget _layananBannerItem(String namaLayanan, Color color) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Layanan Klinik',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  namaLayanan,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.medical_services, size: 56, color: Colors.white),
        ],
      ),
    );
  }

  // ================= JADWAL =================
  Widget _buildJadwalChips() {
    return FutureBuilder<List<DoctorSchedule>>(
      future: _jadwalFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Jadwal dokter belum tersedia'),
          );
        }

        final uniqueSchedules =
            {
              for (var s in snapshot.data!) '${s.hari}-${s.time}': s,
            }.values.toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            children:
                uniqueSchedules
                    .map((s) => _ScheduleChip(s.hari, s.time))
                    .toList(),
          ),
        );
      },
    );
  }

  // ================= DOCTOR PROFILE =================
  Widget _buildDoctorCard() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _dokterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Dokter belum tersedia'),
          );
        }

        return Column(
          children:
              snapshot.data!
                  .map((dokter) => _doctorCardItem(dokter['nama'] as String))
                  .toList(),
        );
      },
    );
  }

  Widget _doctorCardItem(String namaDokter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    namaDokter,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Dokter Gigi', style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      SizedBox(width: 4),
                      Text('5.0'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LOGIN & REGISTER =================
  Widget _buildAuthButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 235, 236, 236),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: Color(0xFF4A90E2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
            child: const Text(
              'Daftar Akun Baru',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF4A90E2),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ================= JADWAL CHIP =================
class _ScheduleChip extends StatelessWidget {
  final String day;
  final String time;

  const _ScheduleChip(this.day, this.time);

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: const Color(0xFF4A90E2).withOpacity(0.1),
      label: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(time, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
