import 'package:flutter/material.dart';
import 'package:klinik/models/UserModel.dart';
import 'package:klinik/models/JadwalModel.dart';
import 'package:klinik/service/JadwalRepository.dart';
import 'package:klinik/page/ChatListPage.dart';
import 'package:klinik/page/JadwalPage.dart';
import 'package:klinik/page/JadwalRutinPage.dart';
import 'package:klinik/page/RekamMedisPage.dart';
import 'package:klinik/page/RiwayatKunjunganPage.dart';
import 'package:klinik/service/RekamMedisRepository.dart';

class HomeContent extends StatefulWidget {
  final UserModel user;
  final String token;

  const HomeContent({super.key, required this.user, required this.token});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final JadwalDokterRepository _repository = JadwalDokterRepository();

  bool _isLoading = true;
  List<DoctorSchedule> _schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    try {
      final data = await _repository.getJadwalDokter(widget.token);
      setState(() {
        _schedules = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error load jadwal: $e');
      setState(() => _isLoading = false);
    }
  }

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
              _buildQuickActions(context),
              _buildDoctorSchedules(context),
              const SizedBox(height: 24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang,',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Cari layanan, dokter...',
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= QUICK ACTION =================
  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Layanan Kami',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
            children: [
              _quickAction(
                icon: Icons.medication,
                label: 'Rekam\nMedis',
                color: const Color(0xFFFFBE0B),
                onTap: () {
                  final repository = RekamMedisRepository();
                  final records = repository.getAllMedicalRecords();

                  if (records.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                MedicalRecordDetailPage(record: records.first),
                      ),
                    );
                  }
                },
              ),
              _quickAction(
                icon: Icons.schedule,
                label: 'Lihat\nJadwal',
                color: Colors.teal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScheduleViewPage(token: widget.token),
                    ),
                  );
                },
              ),
              _quickAction(
                icon: Icons.history,
                label: 'Riwayat\nKunjungan',
                color: const Color(0xFFFF6B6B),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => RiwayatKunjunganPage(
                            patientId: 'P001', // Sesuaikan dengan data login
                            patientName: 'Budi Santoso',
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // ================= JADWAL DOKTER =================
  Widget _buildDoctorSchedules(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER + LIHAT SEMUA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jadwal Praktik Dokter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScheduleViewPage(token: widget.token),
                    ),
                  );
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: Color(0xFF4A90E2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_schedules.isEmpty)
            const Text(
              'Tidak ada jadwal dokter',
              style: TextStyle(color: Colors.grey),
            )
          else
            Column(
              children:
                  _schedules.take(3).map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _doctorCard(e),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _doctorCard(DoctorSchedule schedule) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 28, child: Icon(Icons.person)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.doctorName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Ahli Gigi", style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  '${schedule.hari}, ${schedule.time}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
