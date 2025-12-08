class DoctorSchedule {
  final String id;
  final String doctorName;
  final String specialty;
  final List<String> days;
  final String time;
  final String timeCategory; // pagi, siang, malam
  final String room;
  final bool isAvailable;
  final String phone;
  final String email;
  final String notes;

  DoctorSchedule({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.days,
    required this.time,
    required this.timeCategory,
    required this.room,
    required this.isAvailable,
    required this.phone,
    required this.email,
    this.notes = '',
  });
}
