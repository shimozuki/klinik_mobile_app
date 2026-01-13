import 'package:flutter/material.dart';
import 'package:klinik/content/BookingContent.dart';
import 'dart:ui';

import 'package:klinik/models/AppointmentModel.dart';
import 'package:klinik/page/RekamMedisPage.dart';
import 'package:klinik/service/AppointmentRepository.dart';
import 'package:klinik/service/RekamMedisRepository.dart';
import 'package:klinik/models/ReservasiModel.dart';
import 'package:klinik/service/AuthLocalStorage.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  final records = RekamMedisRepository().getAllMedicalRecords();
  Future<List<ReservasiModel>>? _reservasiFuture;

  Future<void> _loadReservasi() async {
    final token = await AuthLocalStorage.getToken();
    if (token == null) return;

    setState(() {
      _reservasiFuture = AppointmentData().getReservasi(token);
    });
  }

  String _mapStatus(String status) {
    switch (status) {
      case 'menunggu':
        return 'pending';
      case 'dikonfirmasi':
        return 'confirmed';
      case 'selesai':
        return 'completed';
      case 'dibatalkan':
        return 'cancelled';
      default:
        return status;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedTab = _tabController.index);
    });

    _loadReservasi();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header with Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF4A90E2), const Color(0xFF50C9C3)],
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
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
                                  'Jadwal & Booking',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Kelola jadwal kunjungan Anda',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.85),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.calendar_month_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Modern Tab Selector
                        _buildModernTabs(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: FutureBuilder<List<ReservasiModel>>(
                future: _reservasiFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  final data = snapshot.data ?? [];

                  AppointmentData.upcomingAppointments.clear();
                  AppointmentData.completedAppointments.clear();
                  AppointmentData.cancelledAppointments.clear();

                  for (final r in data) {
                    final appointment = Appointment(
                      id: r.id.toString(),
                      doctorName: r.dokter?.name ?? '-',
                      specialty: 'Dokter Gigi',
                      serviceType: r.layanan?.nama ?? '-',
                      date: r.tanggalReservasi.toString().split(' ').first,
                      time: r.jamReservasi ?? '-',
                      status: _mapStatus(r.status),
                    );

                    if (appointment.status == 'pending' ||
                        appointment.status == 'confirmed') {
                      AppointmentData.upcomingAppointments.add(appointment);
                    } else if (appointment.status == 'completed') {
                      AppointmentData.completedAppointments.add(appointment);
                    } else if (appointment.status == 'cancelled') {
                      AppointmentData.cancelledAppointments.add(appointment);
                    }
                  }

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      UpcomingAppointments(records: records),
                      CompletedAppointments(records: records),
                      CancelledAppointments(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A90E2).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showBookingDialog(context),
          backgroundColor: const Color(0xFF4A90E2),
          elevation: 0,
          icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
          label: const Text(
            'Booking Baru',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernTabs() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              _buildTabItem('Menunggu', 0),
              _buildTabItem('Selesai', 1),
              _buildTabItem('Dibatalkan', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color:
                    isSelected
                        ? const Color(0xFF4A90E2)
                        : Colors.white.withOpacity(0.9),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => BookingBottomSheet(
            onBookingSuccess: () {
              _loadReservasi();
            },
          ),
    );
  }
}

// ============= UPCOMING APPOINTMENTS =============
class UpcomingAppointments extends StatelessWidget {
  final List records;

  const UpcomingAppointments({Key? key, required this.records})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final upcomingAppointments = AppointmentData.upcomingAppointments;

    if (upcomingAppointments.isEmpty) {
      return const EmptyStateWidget(
        message: 'Belum ada jadwal kunjungan mendatang',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: upcomingAppointments.length,
      itemBuilder: (context, index) {
        final appointment = upcomingAppointments[index];
        return AppointmentCard(appointment: appointment, records: records);
      },
    );
  }
}

// ============= COMPLETED APPOINTMENTS =============
class CompletedAppointments extends StatelessWidget {
  final List records;

  const CompletedAppointments({Key? key, required this.records})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completedAppointments = AppointmentData.completedAppointments;

    if (completedAppointments.isEmpty) {
      return const EmptyStateWidget(
        message: 'Belum ada jadwal kunjungan selesai',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: completedAppointments.length,
      itemBuilder: (context, index) {
        final appointment = completedAppointments[index];
        return AppointmentCard(
          appointment: appointment,
          records: records, // ✅ BUKAN list kosong
        );
      },
    );
  }
}

// ============= CANCELLED APPOINTMENTS =============
class CancelledAppointments extends StatelessWidget {
  const CancelledAppointments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cancelledAppointments = AppointmentData.cancelledAppointments;

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: cancelledAppointments.length,
      itemBuilder: (context, index) {
        final appointment = cancelledAppointments[index];
        return AppointmentCard(appointment: appointment, records: []);
      },
    );
  }
}

// ============= MODERN APPOINTMENT CARD =============
class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final List? records;
  final VoidCallback? onCancelled;

  const AppointmentCard({
    Key? key,
    required this.appointment,
    required this.records,
    this.onCancelled,
  }) : super(key: key);

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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    // Modern Doctor Avatar
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF4A90E2),
                            const Color(0xFF50C9C3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4A90E2).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Doctor Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.doctorName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A202C),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            appointment.specialty,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildModernStatusBadge(appointment.status),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // Appointment Details Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFF7FAFC),
                        const Color(0xFFEDF2F7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.medical_services_rounded,
                              size: 18,
                              color: const Color(0xFF4A90E2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            appointment.serviceType,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2D3748),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.calendar_today_rounded,
                                    size: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    appointment.date,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.access_time_rounded,
                                    size: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    appointment.time,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Modern Action Buttons
          if (appointment.status == 'confirmed' ||
              appointment.status == 'pending')
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[100]!, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Expanded(
                  //   child: Material(
                  //     color: Colors.transparent,
                  //     child: InkWell(
                  //       onTap: () {},
                  //       borderRadius: const BorderRadius.only(
                  //         bottomLeft: Radius.circular(20),
                  //       ),
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 18),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Icon(
                  //               Icons.chat_bubble_rounded,
                  //               size: 20,
                  //               color: const Color(0xFF4A90E2),
                  //             ),
                  //             const SizedBox(width: 8),
                  //             const Text(
                  //               'Chat',
                  //               style: TextStyle(
                  //                 fontSize: 15,
                  //                 fontWeight: FontWeight.w600,
                  //                 color: Color(0xFF4A90E2),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Container(width: 1, height: 50, color: Colors.grey[100]),
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showCancelDialog(context),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cancel_rounded,
                                size: 20,
                                color: Colors.red[400],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Batalkan',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (appointment.status == 'completed' &&
              records != null &&
              records!.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[100]!, width: 1),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder:
                    //         (context) =>
                    //             MedicalRecordDetailPage(record: records!.first),
                    //   ),
                    // );
                  },
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(
                        //   Icons.star_rounded,
                        //   size: 20,
                        //   color: Colors.amber[600],
                        // ),
                        const SizedBox(width: 8),
                        Text(
                          'Cek Rekam Medis',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4A90E2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModernStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case 'confirmed':
        backgroundColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF065F46);
        text = 'Dikonfirmasi';
        icon = Icons.check_circle_rounded;
        break;
      case 'pending':
        backgroundColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFF92400E);
        text = 'Menunggu';
        icon = Icons.schedule_rounded;
        break;
      case 'completed':
        backgroundColor = const Color(0xFFDBEAFE);
        textColor = const Color(0xFF1E40AF);
        text = 'Selesai';
        icon = Icons.check_circle_outline_rounded;
        break;
      case 'cancelled':
        backgroundColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFF991B1B);
        text = 'Dibatalkan';
        icon = Icons.cancel_rounded;
        break;
      default:
        backgroundColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF6B7280);
        text = status;
        icon = Icons.info_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Batalkan Jadwal'),
            content: const Text(
              'Apakah Anda yakin ingin membatalkan jadwal ini?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Tidak'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);

                  try {
                    final token = await AuthLocalStorage.getToken();
                    if (token == null) return;

                    await AppointmentData.cancelReservasi(
                      token: token,
                      reservasiId: int.parse(appointment.id),
                    );

                    if (onCancelled != null) {
                      onCancelled!();
                    }

                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      const SnackBar(
                        content: Text('Reservasi berhasil dibatalkan'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Ya, Batalkan'),
              ),
            ],
          ),
    );
    // ignore: unused_element
    String _mapStatus(String status) {
      switch (status) {
        case 'menunggu':
          return 'pending';
        case 'dikonfirmasi':
          return 'confirmed';
        case 'selesai':
          return 'completed';
        case 'dibatalkan':
          return 'cancelled';
        default:
          return status;
      }
    }
  }
}

// ============= EMPTY STATE =============
class EmptyStateWidget extends StatelessWidget {
  final String message;

  const EmptyStateWidget({
    Key? key,
    this.message = 'Belum ada data untuk ditampilkan.',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
              ),
              borderRadius: BorderRadius.circular(70),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 70,
              color: const Color(0xFF4ECDC4).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Belum Ada Riwayat',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF95A5A6),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
