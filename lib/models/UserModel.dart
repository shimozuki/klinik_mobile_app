class UserModel {
  final int id;
  final String name;
  final String email;
  final String telepon;

  final String alamat;
  final String nik;
  final String jenisKelamin;
  final String golonganDarah;
  final String alergi;
  final String tanggalLahir;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.alamat,
    required this.nik,
    required this.jenisKelamin,
    required this.golonganDarah,
    required this.alergi,
    required this.tanggalLahir,
    required this.telepon,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = json.containsKey('user') ? json['user'] : json;
    final pasien = userJson['pasien'] ?? {};

    String formatDate(String? isoDate) {
      if (isoDate == null || isoDate.isEmpty) return '';
      return isoDate.split('T').first; // YYYY-MM-DD
    }

    return UserModel(
      id: userJson['id'] ?? 0, // ⬅️ anti crash
      name: userJson['name'] ?? '',
      email: userJson['email'] ?? '',
      telepon: pasien['telepon'] ?? '',
      alamat: pasien['alamat'] ?? '',
      nik: pasien['nik'] ?? '',
      jenisKelamin: pasien['jenis_kelamin'] ?? '',
      golonganDarah: pasien['golongan_darah'] ?? '',
      alergi: pasien['alergi'] ?? '',
      tanggalLahir: formatDate(pasien['tanggal_lahir']) ?? '',
    );
  }

  /// 🔥 TO JSON (WAJIB ADA ID)
  Map<String, dynamic> toJson() {
    return {
      'id': id, // ⬅️ INI KUNCI
      'name': name,
      'email': email,
      'telepone': telepon,
      'pasien': {
        'alamat': alamat,
        'nik': nik,
        'jenis_kelamin': jenisKelamin,
        'golongan_darah': golonganDarah,
        'alergi': alergi,
        'tanggal_lahir': tanggalLahir,
      },
    };
  }

  Map<String, dynamic> toUpdateProfileJson() {
    return {
      'name': name,
      'alamat': alamat,
      'telepon': telepon,
      'nik': nik,
      'tanggal_lahir': tanggalLahir,
      'jenis_kelamin': jenisKelamin,
      'golongan_darah': golonganDarah,
      'alergi': alergi,
    };
  }
}
