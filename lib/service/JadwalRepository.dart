import 'package:klinik/models/JadwalModel.dart';

class ScheduleData {
  static final List<DoctorSchedule> allSchedules = [
    // Senin - Pagi
    DoctorSchedule(
      id: '1',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Senin'],
      time: '08:00 - 12:00',
      timeCategory: 'pagi',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Melayani pasien umum dan BPJS',
    ),
    // Senin - Siang
    DoctorSchedule(
      id: '2',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Senin'],
      time: '13:00 - 17:00',
      timeCategory: 'siang',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Melayani pasien umum dan BPJS',
    ),
    // Senin - Malam
    DoctorSchedule(
      id: '3',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Senin'],
      time: '19:00 - 21:00',
      timeCategory: 'malam',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Praktik malam (dengan perjanjian)',
    ),

    // Selasa - Pagi
    DoctorSchedule(
      id: '4',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Selasa'],
      time: '08:00 - 12:00',
      timeCategory: 'pagi',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Melayani pasien umum dan BPJS',
    ),
    // Selasa - Siang
    DoctorSchedule(
      id: '5',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Selasa'],
      time: '13:00 - 17:00',
      timeCategory: 'siang',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Melayani pasien umum dan BPJS',
    ),
    // Selasa - Malam
    DoctorSchedule(
      id: '6',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Selasa'],
      time: '19:00 - 21:00',
      timeCategory: 'malam',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Praktik malam (dengan perjanjian)',
    ),

    // Rabu - Pagi
    DoctorSchedule(
      id: '7',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Rabu'],
      time: '08:00 - 12:00',
      timeCategory: 'pagi',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Melayani pasien umum dan BPJS',
    ),
    // Rabu - Siang
    DoctorSchedule(
      id: '8',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Rabu'],
      time: '13:00 - 17:00',
      timeCategory: 'siang',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Melayani pasien umum dan BPJS',
    ),
    // Rabu - Malam
    DoctorSchedule(
      id: '9',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Rabu'],
      time: '19:00 - 21:00',
      timeCategory: 'malam',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Praktik malam (dengan perjanjian)',
    ),

    // Kamis - Pagi
    DoctorSchedule(
      id: '10',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Kamis'],
      time: '08:00 - 12:00',
      timeCategory: 'pagi',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Melayani pasien umum dan BPJS',
    ),
    // Kamis - Siang
    DoctorSchedule(
      id: '11',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Kamis'],
      time: '13:00 - 17:00',
      timeCategory: 'siang',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Melayani pasien umum dan BPJS',
    ),
    // Kamis - Malam
    DoctorSchedule(
      id: '12',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Kamis'],
      time: '19:00 - 21:00',
      timeCategory: 'malam',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Praktik malam (dengan perjanjian)',
    ),

    // Jumat - Pagi
    DoctorSchedule(
      id: '13',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Jumat'],
      time: '08:00 - 12:00',
      timeCategory: 'pagi',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Melayani pasien umum dan BPJS',
    ),
    // Jumat - Siang
    DoctorSchedule(
      id: '14',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Jumat'],
      time: '13:00 - 17:00',
      timeCategory: 'siang',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Melayani pasien umum dan BPJS',
    ),
    // Jumat - Malam
    DoctorSchedule(
      id: '15',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Jumat'],
      time: '19:00 - 21:00',
      timeCategory: 'malam',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Praktik malam (dengan perjanjian)',
    ),

    // Sabtu - Pagi
    DoctorSchedule(
      id: '16',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Sabtu'],
      time: '08:00 - 12:00',
      timeCategory: 'pagi',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Praktik setengah hari',
    ),
    // Sabtu - Siang
    DoctorSchedule(
      id: '17',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Sabtu'],
      time: '13:00 - 17:00',
      timeCategory: 'siang',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Praktik setengah hari',
    ),
    // Sabtu - Malam
    DoctorSchedule(
      id: '18',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Sabtu'],
      time: '19:00 - 21:00',
      timeCategory: 'malam',
      room: 'Ruang Praktik',
      isAvailable: false,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Tutup',
    ),

    // Minggu - Pagi
    DoctorSchedule(
      id: '19',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Minggu'],
      time: '08:00 - 12:00',
      timeCategory: 'pagi',
      room: 'Ruang Praktik',
      isAvailable: true,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Praktik hari libur (by appointment)',
    ),
    // Minggu - Siang
    DoctorSchedule(
      id: '20',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Minggu'],
      time: '13:00 - 17:00',
      timeCategory: 'siang',
      room: 'Ruang Praktik',
      isAvailable: false,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Tutup',
    ),
    // Minggu - Malam
    DoctorSchedule(
      id: '21',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      days: ['Minggu'],
      time: '19:00 - 21:00',
      timeCategory: 'malam',
      room: 'Ruang Praktik',
      isAvailable: false,
      phone: '+62 814-5678-9012',
      email: 'amanda.rodriguez@klinik.com',
      notes: 'Tutup',
    ),
  ];

  static List<DoctorSchedule> getSchedulesByDayAndTime(
    String day,
    String timeCategory,
  ) {
    return allSchedules
        .where(
          (schedule) =>
              schedule.days.contains(day) &&
              schedule.timeCategory == timeCategory,
        )
        .toList();
  }

  static List<DoctorSchedule> getSchedulesByDay(String day) {
    return allSchedules
        .where((schedule) => schedule.days.contains(day))
        .toList();
  }
}
