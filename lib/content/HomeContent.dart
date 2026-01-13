import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:klinik/models/UserModel.dart';
import 'package:klinik/models/JadwalModel.dart';
import 'package:klinik/models/ReservasiModel.dart';
import 'package:klinik/page/ListRekamMedis.dart';
import 'package:klinik/page/NotificationPage.dart';
import 'package:klinik/service/JadwalRepository.dart';
import 'package:klinik/service/NotificationRepository.dart';
import 'package:klinik/service/ReservasiRepository.dart';
import 'package:klinik/page/JadwalPage.dart';
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
  final JadwalDokterRepository _jadwalRepository = JadwalDokterRepository();
  final ReservasiRepository _reservasiRepository = ReservasiRepository();

  bool _isLoadingJadwal = true;
  bool _isLoadingReservasi = true;

  List<DoctorSchedule> _schedules = [];
  List<ReservasiModel> _reservasiList = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
    _loadReservasi();

    NotificationRepository().fetchNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('FCM received in foreground');

      // 🔄 ambil ulang notifikasi dari API
      await NotificationRepository().fetchNotifications();
    });
  }

  Future<void> _loadSchedules() async {
    try {
      final data = await _jadwalRepository.getJadwalDokter(widget.token);
      setState(() {
        _schedules = data;
        _isLoadingJadwal = false;
      });
    } catch (e) {
      debugPrint('Error load jadwal: $e');
      setState(() => _isLoadingJadwal = false);
    }
  }

  Future<void> _loadReservasi() async {
    try {
      final data = await _reservasiRepository.getReservasi(widget.token);
      setState(() {
        _reservasiList = data;
        _isLoadingReservasi = false;
      });
    } catch (e) {
      debugPrint('Error load reservasi: $e');
      setState(() => _isLoadingReservasi = false);
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
              _buildUpcomingReservation(),
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
              ValueListenableBuilder<int>(
                valueListenable: NotificationRepository().unreadCountNotifier,
                builder: (context, unread, _) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationPage(),
                            ),
                          );
                        },
                        child: Container(
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
                      ),
                      if (unread > 0)
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  );
                },
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
                        builder: (_) => MedicalRecordListPage(),
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
                      builder: (_) => const RiwayatKunjunganPage(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jadwal Praktik Dokter',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          if (_isLoadingJadwal)
            const Center(child: CircularProgressIndicator())
          else
            Column(children: _schedules.take(3).map(_doctorCard).toList()),
        ],
      ),
    );
  }

  Widget _doctorCard(DoctorSchedule schedule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
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
                    schedule.doctorName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${schedule.hari}, ${schedule.time}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UPCOMING RESERVATION =================
  Widget _buildUpcomingReservation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jadwal Mendatang',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_isLoadingReservasi)
            const Center(child: CircularProgressIndicator())
          else if (_reservasiList.isEmpty)
            const Text('Belum ada reservasi')
          else
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _reservasiList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final r = _reservasiList[index];
                  return Container(
                    width: 260,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.nomorReservasi,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Antrian: ${r.nomorAntrian}',
                          style: const TextStyle(
                            color: Color(0xFF4A90E2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dokter: ${r.dokter!.name}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Waktu: ${r.jadwal!.hari}, ${r.jadwal!.time}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Spacer(),
                        Text(
                          r.status,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
