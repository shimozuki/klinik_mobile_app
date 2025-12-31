class Prescription {
  final String medicineName;
  final String dosage;
  final String frequency;
  final int duration;
  final String? notes;

  Prescription({
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.notes,
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
}
