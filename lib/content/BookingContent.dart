import 'package:flutter/material.dart';
import 'package:klinik/service/AuthLocalStorage.dart';
import 'package:klinik/service/JadwalRepository.dart';
import 'package:klinik/service/ReservasiRepository.dart';
import 'package:klinik/service/OptionRepository.dart';
import 'package:klinik/models/JadwalModel.dart';
import 'package:klinik/models/LayananOption.dart';

class BookingBottomSheet extends StatefulWidget {
  final VoidCallback? onBookingSuccess;
  const BookingBottomSheet({Key? key, this.onBookingSuccess}) : super(key: key);

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  List<DoctorSchedule> jadwalList = [];
  List<LayananOptionModel> layananList = [];

  String? selectedJadwalLabel;
  int? selectedJadwalId;

  String? selectedService;
  int? selectedServiceId;

  final TextEditingController keluhanController = TextEditingController();
  bool isLoading = true;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = await AuthLocalStorage.getToken();
    if (token == null) return;

    final jadwalRepo = JadwalDokterRepository();
    final jadwal = await jadwalRepo.getJadwalDokter(token);
    final layanan = await OptionRepository.getLayanan();

    setState(() {
      jadwalList = jadwal;
      layananList = layanan;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    keluhanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _handle(),
              const SizedBox(height: 28),
              _header(),
              const SizedBox(height: 28),

              // ================== JADWAL ==================
              _label('Pilih Jadwal'),
              const SizedBox(height: 10),
              _box(
                DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: Text(
                    'Pilih jadwal',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  value: selectedJadwalLabel,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey[600],
                  ),
                  items:
                      jadwalList.map((j) {
                        final label =
                            '${j.hari} (${j.jamMulai} - ${j.jamSelesai})';
                        return DropdownMenuItem<String>(
                          value: label,
                          onTap: () => selectedJadwalId = j.id,
                          child: Text(
                            label,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() => selectedJadwalLabel = value);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ================== LAYANAN ==================
              _label('Jenis Layanan'),
              const SizedBox(height: 10),
              _box(
                DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: Text(
                    'Pilih layanan',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  value: selectedService,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey[600],
                  ),
                  items:
                      layananList.map((l) {
                        return DropdownMenuItem<String>(
                          value: l.nama,
                          onTap: () => selectedServiceId = l.id,
                          child: Text(
                            l.nama,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() => selectedService = value);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ================== KELUHAN ==================
              _label('Keluhan'),
              const SizedBox(height: 10),
              _box(
                TextField(
                  controller: keluhanController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Tuliskan keluhan...',
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ================== SUBMIT ==================
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                    shadowColor: const Color(0xFF4A90E2).withOpacity(0.5),
                  ),
                  child:
                      isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Buat Booking',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (selectedJadwalId == null) return;

    setState(() => isSubmitting = true);

    try {
      final token = await AuthLocalStorage.getToken();
      print('Token Booking: $token');
      if (token == null) return;

      await ReservasiRepository.createReservasiSimple(
        token: token,
        jadwalId: selectedJadwalId!,
        keluhan: keluhanController.text,
        layananId: selectedServiceId!,
      );

      // await _loadData();

      if (!mounted) return;

      widget.onBookingSuccess?.call();
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking berhasil dibuat!'),
          backgroundColor: Colors.green,
        ),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  // ================== UI PART ==================
  Widget _handle() => Center(
    child: Container(
      width: 50,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  Widget _header() => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.calendar_month_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
      const SizedBox(width: 16),
      const Text(
        'Buat Booking Baru',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A202C),
        ),
      ),
    ],
  );

  Widget _box(Widget child) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18),
    decoration: BoxDecoration(
      color: const Color(0xFFF7FAFC),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: child,
  );

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 14,
      color: Color(0xFF2D3748),
    ),
  );
}
