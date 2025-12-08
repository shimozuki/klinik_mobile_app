class MedicalRecord {
  final String id;
  final String patientName;
  final String patientId;
  final DateTime visitDate;
  final String doctorName;
  final String complaint;
  final String diagnosis;
  final String treatment;
  final List<Prescription> prescriptions;
  final List<String> procedures;
  final String notes;
  final double totalCost;
  final String status; // completed, in-progress
  final VitalSigns? vitalSigns;

  MedicalRecord({
    required this.id,
    required this.patientName,
    required this.patientId,
    required this.visitDate,
    required this.doctorName,
    required this.complaint,
    required this.diagnosis,
    required this.treatment,
    required this.prescriptions,
    required this.procedures,
    required this.notes,
    required this.totalCost,
    required this.status,
    this.vitalSigns,
  });

  String get formattedDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${visitDate.day} ${months[visitDate.month - 1]} ${visitDate.year}';
  }

  String get visitTime {
    final hour = visitDate.hour.toString().padLeft(2, '0');
    final minute = visitDate.minute.toString().padLeft(2, '0');
    return '$hour:$minute WIB';
  }

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'],
      patientName: json['patientName'],
      patientId: json['patientId'],
      visitDate: DateTime.parse(json['visitDate']),
      doctorName: json['doctorName'],
      complaint: json['complaint'],
      diagnosis: json['diagnosis'],
      treatment: json['treatment'],
      prescriptions:
          (json['prescriptions'] as List)
              .map((e) => Prescription.fromJson(e))
              .toList(),
      procedures: List<String>.from(json['procedures']),
      notes: json['notes'],
      totalCost: json['totalCost'].toDouble(),
      status: json['status'],
      vitalSigns:
          json['vitalSigns'] != null
              ? VitalSigns.fromJson(json['vitalSigns'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'patientId': patientId,
      'visitDate': visitDate.toIso8601String(),
      'doctorName': doctorName,
      'complaint': complaint,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'prescriptions': prescriptions.map((e) => e.toJson()).toList(),
      'procedures': procedures,
      'notes': notes,
      'totalCost': totalCost,
      'status': status,
      'vitalSigns': vitalSigns?.toJson(),
    };
  }
}

class Prescription {
  final String medicineName;
  final String dosage;
  final String frequency;
  final int duration; // dalam hari
  final String notes;

  Prescription({
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.notes,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      medicineName: json['medicineName'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      duration: json['duration'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'notes': notes,
    };
  }
}

class VitalSigns {
  final String bloodPressure; // e.g., "120/80"
  final int heartRate; // bpm
  final double temperature; // celsius
  final int weight; // kg
  final int height; // cm

  VitalSigns({
    required this.bloodPressure,
    required this.heartRate,
    required this.temperature,
    required this.weight,
    required this.height,
  });

  factory VitalSigns.fromJson(Map<String, dynamic> json) {
    return VitalSigns(
      bloodPressure: json['bloodPressure'],
      heartRate: json['heartRate'],
      temperature: json['temperature'].toDouble(),
      weight: json['weight'],
      height: json['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bloodPressure': bloodPressure,
      'heartRate': heartRate,
      'temperature': temperature,
      'weight': weight,
      'height': height,
    };
  }
}
