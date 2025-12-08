// models/dental_visit_model.dart

class DentalVisit {
  final String id;
  final String patientName;
  final String patientId;
  final DateTime visitDate;
  final String visitTime;
  final String treatmentType;
  final String diagnosis;
  final String treatment;
  final List<String> teethNumbers; // Nomor gigi yang ditangani
  final String notes;
  final double treatmentCost;
  final double consultationFee;
  final double additionalCost;
  final String paymentMethod; // cash, transfer, debit, credit
  final String status; // completed, cancelled, scheduled
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
    required this.teethNumbers,
    required this.notes,
    required this.treatmentCost,
    required this.consultationFee,
    required this.additionalCost,
    required this.paymentMethod,
    required this.status,
    this.nextAppointment,
  });

  // Total biaya
  double get totalCost => treatmentCost + consultationFee + additionalCost;

  // Format tanggal Indonesia
  String get formattedDate {
    final months = [
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

  // Format tanggal singkat
  String get shortDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${visitDate.day} ${months[visitDate.month - 1]} ${visitDate.year}';
  }

  // Get status text
  String get statusText {
    switch (status) {
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      case 'scheduled':
        return 'Terjadwal';
      default:
        return 'Unknown';
    }
  }

  // Get payment method text
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

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'patientId': patientId,
      'visitDate': visitDate.toIso8601String(),
      'visitTime': visitTime,
      'treatmentType': treatmentType,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'teethNumbers': teethNumbers,
      'notes': notes,
      'treatmentCost': treatmentCost,
      'consultationFee': consultationFee,
      'additionalCost': additionalCost,
      'paymentMethod': paymentMethod,
      'status': status,
      'nextAppointment': nextAppointment,
    };
  }

  // Create from JSON
  factory DentalVisit.fromJson(Map<String, dynamic> json) {
    return DentalVisit(
      id: json['id'] as String,
      patientName: json['patientName'] as String,
      patientId: json['patientId'] as String,
      visitDate: DateTime.parse(json['visitDate'] as String),
      visitTime: json['visitTime'] as String,
      treatmentType: json['treatmentType'] as String,
      diagnosis: json['diagnosis'] as String,
      treatment: json['treatment'] as String,
      teethNumbers: List<String>.from(json['teethNumbers'] as List),
      notes: json['notes'] as String,
      treatmentCost: (json['treatmentCost'] as num).toDouble(),
      consultationFee: (json['consultationFee'] as num).toDouble(),
      additionalCost: (json['additionalCost'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      nextAppointment: json['nextAppointment'] as String?,
    );
  }

  // Copy with method for updates
  DentalVisit copyWith({
    String? id,
    String? patientName,
    String? patientId,
    DateTime? visitDate,
    String? visitTime,
    String? treatmentType,
    String? diagnosis,
    String? treatment,
    List<String>? teethNumbers,
    String? notes,
    double? treatmentCost,
    double? consultationFee,
    double? additionalCost,
    String? paymentMethod,
    String? status,
    String? nextAppointment,
  }) {
    return DentalVisit(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      patientId: patientId ?? this.patientId,
      visitDate: visitDate ?? this.visitDate,
      visitTime: visitTime ?? this.visitTime,
      treatmentType: treatmentType ?? this.treatmentType,
      diagnosis: diagnosis ?? this.diagnosis,
      treatment: treatment ?? this.treatment,
      teethNumbers: teethNumbers ?? this.teethNumbers,
      notes: notes ?? this.notes,
      treatmentCost: treatmentCost ?? this.treatmentCost,
      consultationFee: consultationFee ?? this.consultationFee,
      additionalCost: additionalCost ?? this.additionalCost,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      nextAppointment: nextAppointment ?? this.nextAppointment,
    );
  }
}

// Model untuk statistik
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
