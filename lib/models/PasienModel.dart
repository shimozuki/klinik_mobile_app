class PasienModel {
  final int id;
  final int userId;
  final String nomorRekamMedis;
  final String nik;
  final DateTime tanggalLahir;
  final String jenisKelamin;
  final String alamat;
  final String telepon;

  // OPTIONAL (sesuai API)
  final String? kontakDarurat;
  final String? teleponDarurat;
  final String? golonganDarah;
  final String? alergi;

  PasienModel({
    required this.id,
    required this.userId,
    required this.nomorRekamMedis,
    required this.nik,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.alamat,
    required this.telepon,
    this.kontakDarurat,
    this.teleponDarurat,
    this.golonganDarah,
    this.alergi,
  });

  factory PasienModel.fromJson(Map<String, dynamic> json) {
    return PasienModel(
      id: json['id'],
      userId: json['user_id'],
      nomorRekamMedis: json['nomor_rekam_medis'] ?? '',
      nik: json['nik'] ?? '',
      tanggalLahir: DateTime.parse(json['tanggal_lahir']),
      jenisKelamin: json['jenis_kelamin'] ?? '',
      alamat: json['alamat'] ?? '',
      telepon: json['telepon'] ?? '',

      kontakDarurat: json['kontak_darurat']?.toString(),
      teleponDarurat: json['telepon_darurat']?.toString(),
      golonganDarah: json['golongan_darah']?.toString(),
      alergi: json['alergi']?.toString(),
    );
  }
}
