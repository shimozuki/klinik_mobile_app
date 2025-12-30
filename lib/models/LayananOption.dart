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
      id: json['id'],
      kode: json['kode'],
      nama: json['nama'],
      harga: double.parse(json['harga'].toString()),
      estimasiDurasi: json['estimasi_durasi'],
    );
  }
}
