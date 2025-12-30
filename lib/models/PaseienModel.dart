class pasienModel {
  final int id;
  final String name;
  final String email;
  final String phone;

  final String alamat;
  final String nik;
  final String jenisKelamin;
  final String golonganDarah;
  final String alergi;
  final String tanggalLahir;

  pasienModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.alamat,
    required this.nik,
    required this.jenisKelamin,
    required this.golonganDarah,
    required this.alergi,
    required this.tanggalLahir,
  });

  factory pasienModel.fromJson(Map<String, dynamic> json) {
    final pasien = json['pasien'] ?? {};

    return pasienModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',

      alamat: pasien['alamat'] ?? '',
      nik: pasien['nik'] ?? '',
      jenisKelamin: pasien['jenis_kelamin'] ?? '',
      golonganDarah: pasien['golongan_darah'] ?? '',
      alergi: pasien['alergi'] ?? '',
      tanggalLahir: pasien['tanggal_lahir'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'alamat': alamat,
      'nik': nik,
      'jenis_kelamin': jenisKelamin,
      'golongan_darah': golonganDarah,
      'alergi': alergi,
      'tanggal_lahir': tanggalLahir,
    };
  }
}
