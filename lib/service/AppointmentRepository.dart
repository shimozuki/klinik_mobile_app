import 'package:klinik/models/AppointmentModel.dart';

class AppointmentData {
  static final List<Appointment> upcomingAppointments = [
    Appointment(
      id: '1',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      serviceType: 'Pemeriksaan Rutin',
      date: '24 Nov 2024',
      time: '10:00 - 11:00',
      status: 'confirmed',
    ),
    Appointment(
      id: '2',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      serviceType: 'Pembersihan Gigi',
      date: '26 Nov 2024',
      time: '14:00 - 15:00',
      status: 'pending',
    ),
    Appointment(
      id: '3',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      serviceType: 'Tambal Gigi',
      date: '28 Nov 2024',
      time: '09:00 - 10:00',
      status: 'confirmed',
    ),
  ];

  static final List<Appointment> completedAppointments = [
    Appointment(
      id: '4',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      serviceType: 'Scaling Gigi',
      date: '15 Nov 2024',
      time: '10:00 - 11:00',
      status: 'completed',
    ),
    Appointment(
      id: '5',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      serviceType: 'Cabut Gigi',
      date: '10 Nov 2024',
      time: '13:00 - 14:00',
      status: 'completed',
    ),
  ];

  static final List<Appointment> cancelledAppointments = [
    Appointment(
      id: '6',
      doctorName: 'drg. Amanda Rodriguez',
      specialty: 'Dokter Gigi',
      serviceType: 'Konsultasi Gigi',
      date: '12 Nov 2024',
      time: '11:00 - 12:00',
      status: 'cancelled',
    ),
  ];

  static final List<Map<String, String>> doctors = [
    {'name': 'drg. Amanda Rodriguez', 'specialty': 'Dokter Gigi'},
  ];

  static final List<String> services = [
    'Pemeriksaan Rutin',
    'Pembersihan Gigi (Scaling)',
    'Tambal Gigi',
    'Cabut Gigi',
    'Perawatan Saluran Akar',
    'Veneer Gigi',
    'Behel/Kawat Gigi',
    'Pemutihan Gigi (Bleaching)',
    'Konsultasi Gigi',
  ];

  // JSON Format untuk API
  static String getUpcomingAppointmentsJson() {
    return '''
{
  "status": "success",
  "data": [
    {
      "id": "1",
      "doctorName": "drg. Amanda Rodriguez",
      "specialty": "Dokter Gigi",
      "serviceType": "Pemeriksaan Rutin",
      "date": "24 Nov 2024",
      "time": "10:00 - 11:00",
      "status": "confirmed"
    },
    {
      "id": "2",
      "doctorName": "drg. Amanda Rodriguez",
      "specialty": "Dokter Gigi",
      "serviceType": "Pembersihan Gigi",
      "date": "26 Nov 2024",
      "time": "14:00 - 15:00",
      "status": "pending"
    }
  ]
}
''';
  }
}
