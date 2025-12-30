import 'package:klinik/models/DokterModel.dart';
import 'package:klinik/models/JadwalModel.dart';
import 'package:klinik/models/LayananOption.dart';

class ReservasiModel {
  final int id;
  final String nomorReservasi;
  final DateTime tanggalReservasi;
  final String? jamReservasi;
  final int nomorAntrian;
  final String status;
  final String? keluhan;

  final LayananOptionModel? layanan;

  final DokterModel? dokter;
  final DoctorSchedule? jadwal;

  ReservasiModel({
    required this.id,
    required this.nomorReservasi,
    required this.tanggalReservasi,
    this.jamReservasi,
    required this.nomorAntrian,
    required this.status,
    this.keluhan,
    this.dokter,
    this.jadwal,
    this.layanan,
  });

  factory ReservasiModel.fromJson(Map<String, dynamic> json) {
    return ReservasiModel(
      id: json['id'],
      nomorReservasi: json['nomor_reservasi'] ?? '',
      tanggalReservasi: DateTime.parse(json['tanggal_reservasi']),
      jamReservasi: json['jam_reservasi']?.toString(),
      nomorAntrian: json['nomor_antrian'] ?? 0,
      status: json['status'] ?? '',
      keluhan: json['keluhan'],
      dokter:
          json['dokter'] != null ? DokterModel.fromJson(json['dokter']) : null,
      jadwal:
          json['jadwal'] != null
              ? DoctorSchedule.fromJson(json['jadwal'])
              : null,
      layanan:
          json['layanan'] != null
              ? LayananOptionModel.fromJson(json['layanan'])
              : null,
    );
  }
}
