import 'package:flutter/material.dart';
import 'package:klinik/content/RiwayatDetailModal.dart';
import 'package:klinik/content/RiwayatKunjunganPaintCard.dart';
import 'package:klinik/models/RiwayatModel.dart';
import 'package:klinik/service/RiwayatRepository.dart';

class RiwayatKunjunganPage extends StatefulWidget {
  final String? patientId;
  final String? patientName;

  const RiwayatKunjunganPage({Key? key, this.patientId, this.patientName})
    : super(key: key);

  @override
  State<RiwayatKunjunganPage> createState() => _RiwayatKunjunganPageState();
}

class _RiwayatKunjunganPageState extends State<RiwayatKunjunganPage> {
  final DentalVisitRepository _repository = DentalVisitRepository();

  List<DentalVisit> _myVisits = [];
  List<DentalVisit> _filteredVisits = [];
  String _selectedFilter = 'Semua';
  bool _isLoading = true;

  // Data pasien
  late String _currentPatientId;
  late String _currentPatientName;

  final List<Map<String, dynamic>> _filters = [
    {'label': 'Semua', 'status': null},
    {'label': 'Selesai', 'status': 'completed'},
    {'label': 'Terjadwal', 'status': 'scheduled'},
    {'label': 'Dibatalkan', 'status': 'cancelled'},
  ];

  @override
  void initState() {
    super.initState();
    _initializePatientData();
    _loadMyVisits();
  }

  // Inisialisasi data pasien (bisa dari parameter atau SharedPreferences)
  void _initializePatientData() {
    // Jika patientId dan patientName di-pass dari parameter
    if (widget.patientId != null && widget.patientName != null) {
      _currentPatientId = widget.patientId!;
      _currentPatientName = widget.patientName!;
    } else {
      // TODO: Ambil dari SharedPreferences atau state management
      // Sementara pakai dummy data
      _currentPatientId = 'P001';
      _currentPatientName = 'Budi Santoso';

      // Contoh dengan SharedPreferences (uncomment jika sudah setup):
      // final prefs = await SharedPreferences.getInstance();
      // _currentPatientId = prefs.getString('patient_id') ?? 'P001';
      // _currentPatientName = prefs.getString('patient_name') ?? 'Guest';
    }
  }

  Future<void> _loadMyVisits() async {
    setState(() => _isLoading = true);

    try {
      final visits = await _repository.getVisitsByPatient(_currentPatientId);

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

  // Apply filter berdasarkan status
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

  // Show snackbar notification
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF2C3E50),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Show detail modal
  void _showVisitDetail(DentalVisit visit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RiwayatDetailModal(visit: visit),
    );
  }

  // Handle filter change
  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
      _applyFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            PatientVisitHeader(
              patientName: _currentPatientName,
              clinicName: _repository.clinicInfo['name'] ?? 'Klinik Gigi',
              onBackPressed: () => Navigator.pop(context),
            ),

            // Content Area
            Expanded(
              child: Column(
                children: [
                  // Filter Chips
                  VisitFilterChips(
                    selectedFilter: _selectedFilter,
                    filters: _filters,
                    onFilterSelected: _onFilterSelected,
                  ),

                  // Statistics Card (hanya tampil jika ada data)
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

                  // Main Content (List atau Empty State)
                  Expanded(child: _buildMainContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build main content area
  Widget _buildMainContent() {
    // Loading State
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
        ),
      );
    }

    // Empty State
    if (_filteredVisits.isEmpty) {
      return EmptyStateWidget(
        message:
            _selectedFilter != 'Semua'
                ? 'Tidak ada kunjungan dengan status "$_selectedFilter"'
                : 'Anda belum memiliki riwayat kunjungan.\nSilakan buat jadwal kunjungan terlebih dahulu.',
      );
    }

    // List of Visits
    return RefreshIndicator(
      onRefresh: _loadMyVisits,
      color: const Color(0xFF4ECDC4),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        physics: const AlwaysScrollableScrollPhysics(),
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
