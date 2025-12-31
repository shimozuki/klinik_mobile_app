class VitalSigns {
  final String bloodPressure;
  final int heartRate;
  final double temperature;
  final double weight;

  VitalSigns({
    required this.bloodPressure,
    required this.heartRate,
    required this.temperature,
    required this.weight,
  });

  factory VitalSigns.fromJson(Map<String, dynamic> json) {
    return VitalSigns(
      bloodPressure: json['bloodPressure'],
      heartRate: json['heartRate'],
      temperature: (json['temperature'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
    );
  }
}
