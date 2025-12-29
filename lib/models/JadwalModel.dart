class DoctorSchedule {
  final int id;
  final String doctorName;
  final String day; // 🔥 INI YANG KURANG
  final String time;
  final String timeCategory;
  final bool isAvailable;

  DoctorSchedule({
    required this.id,
    required this.doctorName,
    required this.day,
    required this.time,
    required this.timeCategory,
    required this.isAvailable,
  });

  factory DoctorSchedule.fromJson(Map<String, dynamic> json) {
    final start = json['jam_mulai'].substring(0, 5);
    final end = json['jam_selesai'].substring(0, 5);

    return DoctorSchedule(
      id: json['id'],
      doctorName: json['nama_dokter'],
      day: json['hari'], // 🔥 MAPPING DARI API
      time: '$start - $end',
      timeCategory: _timeCategory(start),
      isAvailable: json['status_aktif'] == 1,
    );
  }

  static String _timeCategory(String time) {
    final hour = int.parse(time.split(':')[0]);

    if (hour < 12) return 'pagi';
    if (hour < 18) return 'siang';
    return 'malam';
  }
}
