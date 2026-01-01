class DentalVisit {
  final String id;
  final String patientName;
  final String patientId;
  final DateTime visitDate;
  final String visitTime;
  final String treatmentType;
  final String diagnosis;
  final String treatment;
  final String notes;

  final double treatmentCost;
  final double consultationFee;
  final double totalCost;

  final String paymentMethod;
  final String status;
  final String? nextAppointment;

  DentalVisit({
    required this.id,
    required this.patientName,
    required this.patientId,
    required this.visitDate,
    required this.visitTime,
    required this.treatmentType,
    required this.diagnosis,
    required this.treatment,
    required this.notes,
    required this.treatmentCost,
    required this.consultationFee,
    required this.totalCost,
    required this.paymentMethod,
    required this.status,
    this.nextAppointment,
  });

  String get formattedDate {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${visitDate.day} ${months[visitDate.month - 1]} ${visitDate.year}';
  }

  String get statusText {
    switch (status) {
      case 'selesai':
        return 'Selesai';
      case 'dibatalkan':
        return 'Dibatalkan';
      case 'dikonfirmasi':
        return 'Proses';
      case 'menunggu':
        return 'Menunggu';
      default:
        return status;
    }
  }

  String get paymentMethodText {
    switch (paymentMethod) {
      case 'cash':
        return 'Tunai';
      case 'transfer':
        return 'Transfer';
      case 'debit':
        return 'Kartu Debit';
      case 'credit':
        return 'Kartu Kredit';
      default:
        return paymentMethod;
    }
  }

  factory DentalVisit.fromJson(Map<String, dynamic> json) {
    return DentalVisit(
      id: json['id'].toString(),
      patientName: json['patientName'] ?? '',
      patientId: json['patientId'] ?? '',
      visitDate: DateTime.parse(json['visitDate']),
      visitTime: json['visitTime'] ?? '-',
      treatmentType: json['treatmentType'] ?? 'Konsultasi',
      diagnosis: json['diagnosis'] ?? '',
      treatment: json['treatment'] ?? '',
      notes: json['notes'] ?? '',

      // 🔥 SAFE CASTING
      treatmentCost:
          double.tryParse(json['treatmentCost']?.toString() ?? '0') ?? 0.0,

      consultationFee:
          double.tryParse(json['consultationFee']?.toString() ?? '0') ?? 0.0,

      totalCost:
          double.tryParse(
            json['additionalCost']?.toString() ??
                json['totalCost']?.toString() ??
                '0',
          ) ??
          0.0,

      paymentMethod: json['paymentMethod'] ?? 'cash',
      status: _mapStatus(json['status']),
      nextAppointment: json['nextAppointment'],
    );
  }

  // 🔥 MAP STATUS BACKEND → FRONTEND
  static String _mapStatus(String? status) {
    switch (status) {
      case 'dikonfirmasi':
      case 'menunggu':
        return 'scheduled';
      case 'selesai':
        return 'completed';
      case 'dibatalkan':
        return 'cancelled';
      default:
        return status ?? 'completed';
    }
  }
}

class VisitStatistics {
  final int totalVisits;
  final int completedVisits;
  final int cancelledVisits;
  final int scheduledVisits;
  final double totalRevenue;
  final String mostCommonTreatment;

  VisitStatistics({
    required this.totalVisits,
    required this.completedVisits,
    required this.cancelledVisits,
    required this.scheduledVisits,
    required this.totalRevenue,
    required this.mostCommonTreatment,
  });
}
