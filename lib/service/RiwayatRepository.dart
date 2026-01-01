import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:klinik/config/ApiConfig.dart';
import 'package:klinik/models/RiwayatModel.dart';

class RiwayatRepository {
  static String _baseUrl = ApiConfig.baseUrl;

  Future<List<DentalVisit>> getAllRiwayat(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/riwayat'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      print(token);
      return data.map((e) => DentalVisit.fromJson(e)).toList();
    } else {
      print(token);
      throw Exception('Gagal mengambil riwayat');
    }
  }

  Future<VisitStatistics> getStatistics(String token) async {
    final visits = await getAllRiwayat(token);
    final completed = visits.where((v) => v.status == 'completed').toList();

    return VisitStatistics(
      totalVisits: visits.length,
      completedVisits: completed.length,
      cancelledVisits: visits.where((v) => v.status == 'cancelled').length,
      scheduledVisits: visits.where((v) => v.status == 'scheduled').length,
      totalRevenue: completed.fold<double>(0.0, (sum, v) => sum + v.totalCost),
      mostCommonTreatment: _mostCommonTreatment(completed),
    );
  }

  String _mostCommonTreatment(List<DentalVisit> visits) {
    if (visits.isEmpty) return 'Belum ada data';

    final Map<String, int> map = {};
    for (final v in visits) {
      map[v.treatmentType] = (map[v.treatmentType] ?? 0) + 1;
    }

    return map.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
