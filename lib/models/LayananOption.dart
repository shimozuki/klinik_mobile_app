class LayananOptionModel {
  final int id;
  final String kode;
  final String nama;
  final double harga;
  final int? estimasiDurasi;

  LayananOptionModel({
    required this.id,
    required this.kode,
    required this.nama,
    required this.harga,
    this.estimasiDurasi,
  });

  factory LayananOptionModel.fromJson(Map<String, dynamic> json) {
    return LayananOptionModel(
      id: json['id'] ?? 0,
      kode: json['kode']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '-',
      harga:
          json['harga'] != null ? double.parse(json['harga'].toString()) : 0.0,
      estimasiDurasi: json['estimasi_durasi'],
    );
  }
}
