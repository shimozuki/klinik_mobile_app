class ReservasiModel {
  final int id;
  final String nomorReservasi;
  final int pasienId;
  final int dokterId;
  final int jadwalId;
  final DateTime tanggalReservasi;
  final String jamReservasi;
  final int nomorAntrian;
  final String status;
  final String? keluhan;
  final String? catatan;
  final DateTime createdAt;

  ReservasiModel({
    required this.id,
    required this.nomorReservasi,
    required this.pasienId,
    required this.dokterId,
    required this.jadwalId,
    required this.tanggalReservasi,
    required this.jamReservasi,
    required this.nomorAntrian,
    required this.status,
    this.keluhan,
    this.catatan,
    required this.createdAt,
  });

  factory ReservasiModel.fromJson(Map<String, dynamic> json) {
    return ReservasiModel(
      id: json['id'],
      nomorReservasi: json['nomor_reservasi'],
      pasienId: json['pasien_id'],
      dokterId: json['dokter_id'],
      jadwalId: json['jadwal_id'],
      tanggalReservasi: DateTime.parse(json['tanggal_reservasi']),
      jamReservasi: json['jam_reservasi'],
      nomorAntrian: json['nomor_antrian'],
      status: json['status'],
      keluhan: json['keluhan'],
      catatan: json['catatan'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
