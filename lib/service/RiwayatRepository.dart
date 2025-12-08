// ignore_for_file: unused_import, unused_field

import 'dart:convert';
import 'package:klinik/models/RiwayatModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DentalVisitRepository {
  // Singleton pattern
  static final DentalVisitRepository _instance =
      DentalVisitRepository._internal();
  factory DentalVisitRepository() => _instance;
  DentalVisitRepository._internal();

  final String _storageKey = 'dental_visits';

  // Informasi Klinik
  final Map<String, String> clinicInfo = {
    'name': 'Klinik Gigi Senyum Sehat',
    'doctorName': 'drg. Amanda Rodriguez',
    'address': 'Jl. Sudirman No. 123, Jakarta',
    'phone': '021-12345678',
    'email': 'info@klinikgigi.com',
  };

  // Dummy data untuk development
  List<DentalVisit> _dummyVisits = [
    DentalVisit(
      id: '1',
      patientName: 'Budi Santoso',
      patientId: 'P001',
      visitDate: DateTime(2024, 11, 20),
      visitTime: '09:00 - 10:00',
      treatmentType: 'Pembersihan Karang Gigi',
      diagnosis: 'Penumpukan karang gigi di bagian bawah',
      treatment: 'Scaling dan polishing gigi',
      teethNumbers: ['31', '32', '41', '42'],
      notes: 'Pasien dianjurkan untuk kontrol 6 bulan lagi',
      treatmentCost: 350000,
      consultationFee: 100000,
      additionalCost: 0,
      paymentMethod: 'cash',
      status: 'completed',
      nextAppointment: '20 Mei 2025',
    ),
    DentalVisit(
      id: '2',
      patientName: 'Siti Nurhaliza',
      patientId: 'P002',
      visitDate: DateTime(2024, 11, 18),
      visitTime: '10:00 - 11:30',
      treatmentType: 'Penambalan Gigi',
      diagnosis: 'Karies gigi pada gigi geraham atas kanan',
      treatment: 'Penambalan gigi dengan komposit',
      teethNumbers: ['16'],
      notes: 'Hindari makanan keras selama 24 jam',
      treatmentCost: 250000,
      consultationFee: 100000,
      additionalCost: 50000,
      paymentMethod: 'transfer',
      status: 'completed',
      nextAppointment: null,
    ),
    DentalVisit(
      id: '3',
      patientName: 'Ahmad Wijaya',
      patientId: 'P003',
      visitDate: DateTime(2024, 11, 15),
      visitTime: '13:00 - 14:00',
      treatmentType: 'Konsultasi Ortodonti',
      diagnosis: 'Gigi tidak teratur, memerlukan perawatan behel',
      treatment: 'Konsultasi dan pembuatan cetakan gigi',
      teethNumbers: [],
      notes: 'Rencana pemasangan behel bulan depan',
      treatmentCost: 150000,
      consultationFee: 100000,
      additionalCost: 0,
      paymentMethod: 'debit',
      status: 'completed',
      nextAppointment: '15 Desember 2024',
    ),
    DentalVisit(
      id: '4',
      patientName: 'Dewi Lestari',
      patientId: 'P004',
      visitDate: DateTime(2024, 11, 12),
      visitTime: '14:00 - 15:00',
      treatmentType: 'Pencabutan Gigi',
      diagnosis: 'Gigi geraham bawah kiri rusak parah',
      treatment: 'Ekstraksi gigi geraham',
      teethNumbers: ['36'],
      notes: 'Minum antibiotik 3x sehari selama 5 hari',
      treatmentCost: 300000,
      consultationFee: 100000,
      additionalCost: 100000,
      paymentMethod: 'cash',
      status: 'completed',
      nextAppointment: '19 November 2024 (kontrol)',
    ),
    DentalVisit(
      id: '5',
      patientName: 'Rudi Hermawan',
      patientId: 'P005',
      visitDate: DateTime(2024, 11, 8),
      visitTime: '15:00 - 16:00',
      treatmentType: 'Perawatan Saluran Akar',
      diagnosis: 'Infeksi pada pulpa gigi',
      treatment: 'Root canal treatment sesi 1 dari 3',
      teethNumbers: ['26'],
      notes: 'Lanjut sesi 2 minggu depan',
      treatmentCost: 800000,
      consultationFee: 100000,
      additionalCost: 0,
      paymentMethod: 'credit',
      status: 'completed',
      nextAppointment: '15 November 2024',
    ),
    DentalVisit(
      id: '6',
      patientName: 'Linda Kusuma',
      patientId: 'P006',
      visitDate: DateTime(2024, 11, 5),
      visitTime: '11:00 - 12:00',
      treatmentType: 'Pemutihan Gigi',
      diagnosis: 'Gigi kuning akibat konsumsi kopi',
      treatment: 'Bleaching gigi professional',
      teethNumbers: [],
      notes: 'Hasil bertahan 1-2 tahun dengan perawatan baik',
      treatmentCost: 1500000,
      consultationFee: 100000,
      additionalCost: 200000,
      paymentMethod: 'transfer',
      status: 'completed',
      nextAppointment: null,
    ),
    DentalVisit(
      id: '7',
      patientName: 'Eko Prasetyo',
      patientId: 'P007',
      visitDate: DateTime(2024, 10, 30),
      visitTime: '09:00 - 10:00',
      treatmentType: 'Pembersihan Rutin',
      diagnosis: 'Pemeriksaan rutin 6 bulan',
      treatment: 'Scaling ringan dan konsultasi',
      teethNumbers: [],
      notes: 'Kondisi gigi baik, pertahankan kebersihan',
      treatmentCost: 200000,
      consultationFee: 100000,
      additionalCost: 0,
      paymentMethod: 'cash',
      status: 'completed',
      nextAppointment: '30 April 2025',
    ),
    DentalVisit(
      id: '8',
      patientName: 'Maya Sari',
      patientId: 'P008',
      visitDate: DateTime(2024, 10, 25),
      visitTime: '13:00 - 13:30',
      treatmentType: 'Konsultasi',
      diagnosis: 'Sakit gigi',
      treatment: 'Konsultasi dan resep obat',
      teethNumbers: [],
      notes: 'Pasien tidak jadi melanjutkan perawatan',
      treatmentCost: 0,
      consultationFee: 100000,
      additionalCost: 0,
      paymentMethod: 'cash',
      status: 'cancelled',
      nextAppointment: null,
    ),
    DentalVisit(
      id: '9',
      patientName: 'Andi Setiawan',
      patientId: 'P009',
      visitDate: DateTime(2024, 12, 5),
      visitTime: '10:00 - 11:00',
      treatmentType: 'Kontrol Behel',
      diagnosis: 'Kontrol rutin behel bulan ke-3',
      treatment: 'Penyesuaian kawat behel',
      teethNumbers: [],
      notes: 'Jadwal terjadwal',
      treatmentCost: 150000,
      consultationFee: 0,
      additionalCost: 0,
      paymentMethod: 'transfer',
      status: 'scheduled',
      nextAppointment: '5 Januari 2025',
    ),
    DentalVisit(
      id: '10',
      patientName: 'Fitri Handayani',
      patientId: 'P010',
      visitDate: DateTime(2024, 12, 8),
      visitTime: '14:00 - 15:00',
      treatmentType: 'Pemasangan Mahkota Gigi',
      diagnosis: 'Gigi depan patah',
      treatment: 'Pemasangan dental crown',
      teethNumbers: ['11'],
      notes: 'Jadwal terjadwal',
      treatmentCost: 2500000,
      consultationFee: 0,
      additionalCost: 0,
      paymentMethod: 'credit',
      status: 'scheduled',
      nextAppointment: null,
    ),
  ];

  // Get all visits
  Future<List<DentalVisit>> getAllVisits() async {
    try {
      // Uncomment ini ketika sudah pakai shared_preferences
      // final prefs = await SharedPreferences.getInstance();
      // final String? visitsJson = prefs.getString(_storageKey);

      // if (visitsJson != null) {
      //   final List<dynamic> decoded = json.decode(visitsJson);
      //   return decoded.map((json) => DentalVisit.fromJson(json)).toList();
      // }

      // Return dummy data untuk development
      return _dummyVisits;
    } catch (e) {
      print('Error getting visits: $e');
      return [];
    }
  }

  // Get visits by status
  Future<List<DentalVisit>> getVisitsByStatus(String status) async {
    final visits = await getAllVisits();
    return visits.where((visit) => visit.status == status).toList();
  }

  // Get visits by date range
  Future<List<DentalVisit>> getVisitsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final visits = await getAllVisits();
    return visits.where((visit) {
      return visit.visitDate.isAfter(start.subtract(const Duration(days: 1))) &&
          visit.visitDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Get visits by patient
  Future<List<DentalVisit>> getVisitsByPatient(String patientId) async {
    final visits = await getAllVisits();
    return visits.where((visit) => visit.patientId == patientId).toList();
  }

  // Search visits
  Future<List<DentalVisit>> searchVisits(String query) async {
    final visits = await getAllVisits();
    final lowerQuery = query.toLowerCase();

    return visits.where((visit) {
      return visit.patientName.toLowerCase().contains(lowerQuery) ||
          visit.patientId.toLowerCase().contains(lowerQuery) ||
          visit.treatmentType.toLowerCase().contains(lowerQuery) ||
          visit.diagnosis.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Get visit by ID
  Future<DentalVisit?> getVisitById(String id) async {
    final visits = await getAllVisits();
    try {
      return visits.firstWhere((visit) => visit.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new visit
  Future<bool> addVisit(DentalVisit visit) async {
    try {
      final visits = await getAllVisits();
      visits.add(visit);
      return await _saveVisits(visits);
    } catch (e) {
      print('Error adding visit: $e');
      return false;
    }
  }

  // Update visit
  Future<bool> updateVisit(DentalVisit visit) async {
    try {
      final visits = await getAllVisits();
      final index = visits.indexWhere((v) => v.id == visit.id);

      if (index != -1) {
        visits[index] = visit;
        return await _saveVisits(visits);
      }
      return false;
    } catch (e) {
      print('Error updating visit: $e');
      return false;
    }
  }

  // Delete visit
  Future<bool> deleteVisit(String id) async {
    try {
      final visits = await getAllVisits();
      visits.removeWhere((visit) => visit.id == id);
      return await _saveVisits(visits);
    } catch (e) {
      print('Error deleting visit: $e');
      return false;
    }
  }

  // Get statistics
  Future<VisitStatistics> getStatistics() async {
    final visits = await getAllVisits();

    final completed = visits.where((v) => v.status == 'completed').length;
    final cancelled = visits.where((v) => v.status == 'cancelled').length;
    final scheduled = visits.where((v) => v.status == 'scheduled').length;

    final revenue = visits
        .where((v) => v.status == 'completed')
        .fold<double>(0, (sum, visit) => sum + visit.totalCost);

    // Find most common treatment
    final treatmentCounts = <String, int>{};
    for (var visit in visits.where((v) => v.status == 'completed')) {
      treatmentCounts[visit.treatmentType] =
          (treatmentCounts[visit.treatmentType] ?? 0) + 1;
    }

    String mostCommon = 'Belum ada data';
    if (treatmentCounts.isNotEmpty) {
      mostCommon =
          treatmentCounts.entries
              .reduce((a, b) => a.value > b.value ? a : b)
              .key;
    }

    return VisitStatistics(
      totalVisits: visits.length,
      completedVisits: completed,
      cancelledVisits: cancelled,
      scheduledVisits: scheduled,
      totalRevenue: revenue,
      mostCommonTreatment: mostCommon,
    );
  }

  // Private method to save visits to storage
  Future<bool> _saveVisits(List<DentalVisit> visits) async {
    try {
      // Uncomment ini ketika sudah pakai shared_preferences
      // final prefs = await SharedPreferences.getInstance();
      // final String visitsJson = json.encode(
      //   visits.map((visit) => visit.toJson()).toList(),
      // );
      // return await prefs.setString(_storageKey, visitsJson);

      // Untuk development, simpan ke dummy data
      _dummyVisits = visits;
      return true;
    } catch (e) {
      print('Error saving visits: $e');
      return false;
    }
  }

  // Export data as JSON string (untuk backup/export)
  Future<String> exportToJson() async {
    final visits = await getAllVisits();
    return json.encode(visits.map((v) => v.toJson()).toList());
  }

  // Import data from JSON string
  Future<bool> importFromJson(String jsonString) async {
    try {
      final List<dynamic> decoded = json.decode(jsonString);
      final visits = decoded.map((json) => DentalVisit.fromJson(json)).toList();
      return await _saveVisits(visits);
    } catch (e) {
      print('Error importing data: $e');
      return false;
    }
  }
}
