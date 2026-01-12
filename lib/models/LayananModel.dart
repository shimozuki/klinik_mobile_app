class LayananModel {
  final String nama;
  final String deskripsi;
  final int harga;
  final int estimasiDurasi;

  LayananModel({
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.estimasiDurasi,
  });

  factory LayananModel.fromJson(Map<String, dynamic> json) {
    return LayananModel(
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      harga: int.parse(json['harga'].toString().split('.').first),
      estimasiDurasi: json['estimasi_durasi'],
    );
  }
}
