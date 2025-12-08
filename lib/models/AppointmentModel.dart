class Appointment {
  final String id;
  final String doctorName;
  final String specialty;
  final String serviceType;
  final String date;
  final String time;
  final String status;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.serviceType,
    required this.date,
    required this.time,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      doctorName: json['doctorName'],
      specialty: json['specialty'],
      serviceType: json['serviceType'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorName': doctorName,
      'specialty': specialty,
      'serviceType': serviceType,
      'date': date,
      'time': time,
      'status': status,
    };
  }
}
