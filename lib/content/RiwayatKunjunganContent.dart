import 'package:flutter/material.dart';
import 'package:klinik/content/RiwayatKunjunganPaintCard.dart';
import 'package:klinik/content/RiwayatDetailModal.dart';
import 'package:klinik/models/RiwayatModel.dart';
import 'package:klinik/service/AuthLocalStorage.dart';
import 'package:klinik/service/RiwayatRepository.dart';

class RiwayatKunjunganContent extends StatefulWidget {
  const RiwayatKunjunganContent({Key? key}) : super(key: key);

  @override
  State<RiwayatKunjunganContent> createState() =>
      _RiwayatKunjunganContentState();
}

class _RiwayatKunjunganContentState extends State<RiwayatKunjunganContent> {
  final RiwayatRepository _repository = RiwayatRepository();

  List<DentalVisit> _myVisits = []; // Riwayat kunjungan pasien ini saja
  List<DentalVisit> _filteredVisits = [];
  String _selectedFilter = 'Semua';
  bool _isLoading = true;

  final List<Map<String, dynamic>> _filters = [
    {'label': 'Semua', 'status': null},
    {'label': 'Selesai', 'status': 'completed'},
    {'label': 'Menunggu', 'status': 'scheduled'},
    {'label': 'Dibatalkan', 'status': 'cancelled'},
  ];

  @override
  void initState() {
    super.initState();
    _loadMyVisits();
  }

  // Load riwayat kunjungan pasien ini saja
  Future<void> _loadMyVisits() async {
    setState(() => _isLoading = true);

    try {
      final token = await AuthLocalStorage.getToken();
      if (token == null) throw Exception('Token tidak ditemukan');

      final visits = await _repository.getAllRiwayat(token);

      setState(() {
        _myVisits = visits;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Gagal memuat data: $e');
    }
  }

  void _applyFilter() {
    List<DentalVisit> filtered = _myVisits;

    // Filter by status
    if (_selectedFilter != 'Semua') {
      final status =
          _filters.firstWhere((f) => f['label'] == _selectedFilter)['status']
              as String?;

      if (status != null) {
        filtered = filtered.where((v) => v.status == status).toList();
      }
    }

    // Sort by date (newest first)
    filtered.sort((a, b) => b.visitDate.compareTo(a.visitDate));

    setState(() {
      _filteredVisits = filtered;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF2C3E50),
      ),
    );
  }

  void _showVisitDetail(DentalVisit visit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RiwayatDetailModal(visit: visit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan info pasien
            PatientVisitHeader(
              patientName:
                  _filteredVisits.isNotEmpty
                      ? _filteredVisits.first.patientName
                      : 'Pasien',
              clinicName: 'Klinik DRG Ayu Dental Care',
              onBackPressed: () => Navigator.pop(context),
            ),

            Expanded(
              child: Column(
                children: [
                  // Filter Chips (tanpa search bar karena cuma lihat milik sendiri)
                  VisitFilterChips(
                    selectedFilter: _selectedFilter,
                    filters: _filters,
                    onFilterSelected: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                        _applyFilter();
                      });
                    },
                  ),

                  // Statistics Card
                  if (_filteredVisits.isNotEmpty && !_isLoading)
                    PatientStatisticsCard(
                      totalVisits: _filteredVisits.length,
                      completedVisits:
                          _filteredVisits
                              .where((v) => v.status == 'completed')
                              .length,
                      scheduledVisits:
                          _filteredVisits
                              .where((v) => v.status == 'scheduled')
                              .length,
                      totalSpent: _filteredVisits
                          .where((v) => v.status == 'completed')
                          .fold<double>(0, (sum, v) => sum + v.totalCost),
                    ),

                  Expanded(child: _buildContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
        ),
      );
    }

    if (_filteredVisits.isEmpty) {
      return EmptyStateWidget(
        message:
            _selectedFilter != 'Semua'
                ? 'Tidak ada kunjungan dengan status "${_selectedFilter}"'
                : 'Anda belum memiliki riwayat kunjungan',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMyVisits,
      color: const Color(0xFF4ECDC4),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        itemCount: _filteredVisits.length,
        itemBuilder: (context, index) {
          final visit = _filteredVisits[index];
          return PatientVisitCard(
            visit: visit,
            onTap: () => _showVisitDetail(visit),
          );
        },
      ),
    );
  }
}
