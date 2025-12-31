import 'package:klinik/models/PrescriptionModel.dart';
import 'package:klinik/models/VitalSignsModel.dart';

class ListRekamMedisModel {
  final String id;
  final String patientName;
  final String patientId;
  final DateTime visitDate;
  final String doctorName;
  final String complaint;
  final String diagnosis;
  final List<Prescription> prescriptions;
  final List<String> procedures;
  final int totalCost;
  final String status;
  final VitalSigns vitalSigns;
  final String notes;

  ListRekamMedisModel({
    required this.id,
    required this.patientName,
    required this.patientId,
    required this.visitDate,
    required this.doctorName,
    required this.complaint,
    required this.diagnosis,
    required this.prescriptions,
    required this.totalCost,
    required this.status,
    required this.notes,
    required this.vitalSigns,
    List<String>? procedures,
  }) : procedures =
           procedures ??
           [
             'Pemeriksaan klinis dan tes vitalitas pulpa',
             'Foto rontgen periapikal',
             'Pembersihan area fraktur',
             'Etsa asam pada permukaan email',
             'Aplikasi bonding agent',
             'Penumpukan komposit berlapis (layering technique)',
             'Konturing dan polishing',
           ];

  factory ListRekamMedisModel.fromJson(Map<String, dynamic> json) {
    return ListRekamMedisModel(
      id: json['id'],
      patientName: json['patientName'],
      patientId: json['patientId'],
      visitDate: DateTime.parse(json['visitDate']),
      doctorName: json['doctorName'],
      complaint: json['complaint'],
      diagnosis: json['diagnosis'],
      notes: json['notes'],
      prescriptions:
          (json['prescriptions'] as List)
              .map((e) => Prescription.fromJson(e))
              .toList(),
      totalCost: json['totalCost'],
      status: json['status'],
      vitalSigns: VitalSigns.fromJson(json['vitalSigns']),
      // procedures sengaja TIDAK diambil dari API
      // karena sudah ada default value
    );
  }

  /// Helper untuk UI
  String get formattedDate =>
      "${visitDate.day.toString().padLeft(2, '0')}/"
      "${visitDate.month.toString().padLeft(2, '0')}/"
      "${visitDate.year}";
}
