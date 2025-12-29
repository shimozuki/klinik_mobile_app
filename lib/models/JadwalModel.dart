class DoctorSchedule {
  final int id;
  final String doctorName;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final int kuota;
  final bool statusAktif;

  DoctorSchedule({
    required this.id,
    required this.doctorName,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.kuota,
    required this.statusAktif,
  });

  factory DoctorSchedule.fromJson(Map<String, dynamic> json) {
    return DoctorSchedule(
      id: json['id'],
      doctorName: json['nama_dokter'],
      hari: json['hari'],
      jamMulai: json['jam_mulai'],
      jamSelesai: json['jam_selesai'],
      kuota: json['kuota'],
      statusAktif: json['status_aktif'] == 1,
    );
  }

  String get time => '$jamMulai - $jamSelesai';

  bool get isAvailable => statusAktif && kuota > 0;

  String get timeCategory {
    final hour = int.parse(jamMulai.substring(0, 2));
    if (hour < 12) return 'pagi';
    if (hour < 18) return 'siang';
    return 'malam';
  }
}
