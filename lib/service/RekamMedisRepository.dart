import 'package:klinik/models/RekamMedisModel.dart';

class RekamMedisRepository {
  // Singleton pattern
  static final RekamMedisRepository _instance =
      RekamMedisRepository._internal();
  factory RekamMedisRepository() => _instance;
  RekamMedisRepository._internal();

  // Data dummy rekam medis klinik gigi
  final List<MedicalRecord> _medicalRecords = [
    MedicalRecord(
      id: 'MR001',
      patientName: 'Budi Santoso',
      patientId: 'P001',
      visitDate: DateTime(2024, 11, 25, 10, 30),
      doctorName: 'drg. Sarah Wijaya, Sp.KG',
      complaint:
          'Sakit gigi berlubang di geraham kanan bawah sejak 3 hari yang lalu. Nyeri semakin parah saat makan dan minum dingin.',
      diagnosis:
          'Karies Profunda pada gigi 46 (geraham kanan bawah) dengan pulpitis reversibel',
      treatment:
          'Penambalan gigi dengan teknik restorasi komposit resin setelah pembersihan jaringan karies',
      procedures: [
        'Pemeriksaan klinis intraoral',
        'Pemeriksaan dengan sonde dan kaca mulut',
        'Pembersihan karies dengan bur',
        'Aplikasi basis kalsium hidroksida',
        'Penambalan dengan komposit resin',
        'Pengecekan oklusi dan finishing',
      ],
      prescriptions: [
        Prescription(
          medicineName: 'Asam Mefenamat 500mg',
          dosage: '1 tablet',
          frequency: '3x sehari setelah makan',
          duration: 3,
          notes: 'Untuk mengurangi nyeri pasca perawatan',
        ),
        Prescription(
          medicineName: 'Chlorhexidine Gluconate 0.2% (Obat Kumur)',
          dosage: '10-15 ml',
          frequency: '2x sehari (pagi dan malam)',
          duration: 7,
          notes:
              'Berkumur selama 30 detik, jangan langsung makan/minum setelahnya',
        ),
      ],
      notes:
          'Pasien disarankan menghindari makanan/minuman yang terlalu panas, dingin, atau keras pada area yang ditambal selama 24 jam. Jaga kebersihan mulut dengan menyikat gigi 2x sehari. Kontrol kembali 1 minggu untuk evaluasi.',
      totalCost: 450000,
      status: 'completed',
      vitalSigns: VitalSigns(
        bloodPressure: '120/80',
        heartRate: 78,
        temperature: 36.5,
        weight: 68,
        height: 170,
      ),
    ),
    MedicalRecord(
      id: 'MR002',
      patientName: 'Siti Nurhaliza',
      patientId: 'P002',
      visitDate: DateTime(2024, 11, 20, 14, 15),
      doctorName: 'drg. Ahmad Fauzi, Sp.Ort',
      complaint:
          'Gigi depan atas patah sebagian akibat terjatuh saat berolahraga. Terasa ngilu dan mengganggu penampilan.',
      diagnosis:
          'Fraktur email-dentin gigi 11 (gigi seri tengah kanan atas) tanpa keterlibatan pulpa',
      treatment:
          'Restorasi estetik dengan teknik direct composite veneer untuk mengembalikan bentuk dan fungsi gigi',
      procedures: [
        'Pemeriksaan klinis dan tes vitalitas pulpa',
        'Foto rontgen periapikal',
        'Pembersihan area fraktur',
        'Etsa asam pada permukaan email',
        'Aplikasi bonding agent',
        'Penumpukan komposit berlapis (layering technique)',
        'Konturing dan polishing',
      ],
      prescriptions: [
        Prescription(
          medicineName: 'Ibuprofen 400mg',
          dosage: '1 tablet',
          frequency: '3x sehari setelah makan',
          duration: 3,
          notes: 'Bila nyeri, tidak wajib diminum jika tidak sakit',
        ),
        Prescription(
          medicineName: 'Sensodyne Repair & Protect (Pasta Gigi)',
          dosage: 'Secukupnya',
          frequency: '2x sehari saat menyikat gigi',
          duration: 30,
          notes: 'Untuk mengurangi sensitivitas gigi',
        ),
      ],
      notes:
          'Pasien disarankan menggunakan pelindung mulut (mouthguard) saat berolahraga. Hindari menggigit makanan keras dengan gigi depan. Kontrol rutin setiap 6 bulan untuk poles ulang dan evaluasi.',
      totalCost: 850000,
      status: 'completed',
      vitalSigns: VitalSigns(
        bloodPressure: '110/70',
        heartRate: 72,
        temperature: 36.7,
        weight: 55,
        height: 158,
      ),
    ),
    MedicalRecord(
      id: 'MR003',
      patientName: 'Andi Pratama',
      patientId: 'P003',
      visitDate: DateTime(2024, 11, 27, 9, 0),
      doctorName: 'drg. Linda Kusuma, Sp.Perio',
      complaint:
          'Gusi bengkak, berdarah saat menyikat gigi, dan bau mulut tidak sedap sejak 2 minggu terakhir.',
      diagnosis:
          'Gingivitis kronis dengan kalkulus supragingival dan subgingival generalisata',
      treatment:
          'Scaling dan root planing (pembersihan karang gigi) pada seluruh kuadran rahang',
      procedures: [
        'Pemeriksaan periodontal dengan probing',
        'Scaling supragingival dengan ultrasonic scaler',
        'Scaling subgingival manual dengan kuret',
        'Root planing',
        'Irigasi poket dengan larutan antiseptik',
        'Aplikasi fluor',
        'Instruksi kebersihan mulut (oral hygiene instruction)',
      ],
      prescriptions: [
        Prescription(
          medicineName: 'Amoxicillin 500mg',
          dosage: '1 kapsul',
          frequency: '3x sehari setelah makan',
          duration: 5,
          notes: 'Antibiotik untuk mencegah infeksi, harus dihabiskan',
        ),
        Prescription(
          medicineName: 'Metronidazole 500mg',
          dosage: '1 tablet',
          frequency: '3x sehari setelah makan',
          duration: 5,
          notes:
              'Kombinasi antibiotik, hindari alkohol selama konsumsi obat ini',
        ),
        Prescription(
          medicineName: 'Chlorhexidine Gluconate 0.2% (Obat Kumur)',
          dosage: '10-15 ml',
          frequency: '2x sehari setelah menyikat gigi',
          duration: 14,
          notes: 'Berkumur selama 30 detik untuk mengurangi bakteri',
        ),
      ],
      notes:
          'Pasien diedukasi teknik menyikat gigi yang benar (metode bass) dan penggunaan dental floss. Hindari merokok. Gusi mungkin terasa sensitif 2-3 hari pasca scaling. Kontrol kembali 2 minggu untuk evaluasi penyembuhan gusi.',
      totalCost: 650000,
      status: 'completed',
      vitalSigns: VitalSigns(
        bloodPressure: '118/78',
        heartRate: 75,
        temperature: 36.6,
        weight: 72,
        height: 175,
      ),
    ),
    MedicalRecord(
      id: 'MR004',
      patientName: 'Dewi Lestari',
      patientId: 'P004',
      visitDate: DateTime(2024, 11, 15, 11, 30),
      doctorName: 'drg. Bambang Suryanto, Sp.BM',
      complaint:
          'Gigi geraham bawah kiri sangat sakit, bengkak di pipi, dan susah membuka mulut sejak 2 hari yang lalu.',
      diagnosis:
          'Abses periapikal pada gigi 36 (geraham pertama kiri bawah) dengan pulpa nekrosis',
      treatment:
          'Perawatan saluran akar (root canal treatment) dengan drainase abses dan medikasi intrakanal',
      procedures: [
        'Foto rontgen periapikal',
        'Insisi dan drainase abses',
        'Akses kavitas',
        'Ekstirpasi jaringan pulpa nekrotik',
        'Pengukuran panjang kerja dengan apex locator',
        'Preparasi dan pembersihan saluran akar',
        'Irigasi dengan NaOCl dan EDTA',
        'Medikasi intrakanal kalsium hidroksida',
        'Penutupan sementara',
      ],
      prescriptions: [
        Prescription(
          medicineName: 'Amoxicillin 500mg',
          dosage: '1 kapsul',
          frequency: '3x sehari setelah makan',
          duration: 7,
          notes: 'Antibiotik untuk mengatasi infeksi, harus dihabiskan',
        ),
        Prescription(
          medicineName: 'Asam Mefenamat 500mg',
          dosage: '1 tablet',
          frequency: '3x sehari setelah makan',
          duration: 5,
          notes: 'Untuk mengurangi nyeri dan inflamasi',
        ),
        Prescription(
          medicineName: 'Dexamethasone 0.5mg',
          dosage: '1 tablet',
          frequency: '3x sehari setelah makan',
          duration: 3,
          notes: 'Anti inflamasi untuk mengurangi bengkak',
        ),
      ],
      notes:
          'Pasien dijadwalkan untuk kunjungan berikutnya 1 minggu lagi untuk penggantian medikasi intrakanal dan pengisian saluran akar. Setelah itu dilanjutkan dengan pembuatan mahkota tiruan untuk melindungi gigi. Hindari mengunyah pada sisi yang sakit.',
      totalCost: 1250000,
      status: 'in-progress',
      vitalSigns: VitalSigns(
        bloodPressure: '135/85',
        heartRate: 88,
        temperature: 37.2,
        weight: 65,
        height: 160,
      ),
    ),
    MedicalRecord(
      id: 'MR005',
      patientName: 'Rudi Hartono',
      patientId: 'P005',
      visitDate: DateTime(2024, 11, 22, 15, 45),
      doctorName: 'drg. Maya Sari, Sp.Pros',
      complaint:
          'Ingin memasang gigi palsu untuk menggantikan gigi geraham atas yang sudah dicabut 6 bulan lalu.',
      diagnosis:
          'Missing tooth (kehilangan gigi) pada regio 16 (geraham pertama kanan atas)',
      treatment:
          'Pembuatan gigi tiruan jembatan (dental bridge) 3 unit dengan preparasi gigi penyangga',
      procedures: [
        'Pemeriksaan klinis dan foto rontgen panoramik',
        'Preparasi gigi 15 dan 17 sebagai abutment',
        'Pencetakan rahang dengan bahan silikon',
        'Penentuan warna gigi dengan shade guide',
        'Pemasangan bridge sementara',
        'Try-in bridge permanen',
        'Sementasi bridge dengan glass ionomer cement',
        'Pengecekan oklusi dan artikulasi',
      ],
      prescriptions: [
        Prescription(
          medicineName: 'Ibuprofen 400mg',
          dosage: '1 tablet',
          frequency: 'Bila perlu (maksimal 3x sehari)',
          duration: 3,
          notes: 'Untuk mengatasi ketidaknyamanan pasca preparasi',
        ),
        Prescription(
          medicineName: 'Sensodyne Rapid Relief (Pasta Gigi)',
          dosage: 'Secukupnya',
          frequency: '2x sehari',
          duration: 30,
          notes: 'Untuk mengurangi sensitivitas pada gigi yang dipreparasi',
        ),
      ],
      notes:
          'Pasien diedukasi cara membersihkan area di bawah pontic (gigi palsu) dengan dental floss khusus atau interdental brush. Hindari makanan yang terlalu keras atau lengket. Kontrol rutin setiap 6 bulan untuk evaluasi dan pembersihan profesional.',
      totalCost: 3500000,
      status: 'completed',
      vitalSigns: VitalSigns(
        bloodPressure: '125/82',
        heartRate: 76,
        temperature: 36.5,
        weight: 75,
        height: 172,
      ),
    ),
    MedicalRecord(
      id: 'MR006',
      patientName: 'Nina Maharani',
      patientId: 'P006',
      visitDate: DateTime(2024, 11, 18, 13, 0),
      doctorName: 'drg. Sarah Wijaya, Sp.KG',
      complaint:
          'Gigi depan bawah berjejal dan tidak rapi. Ingin merapikan gigi untuk meningkatkan kepercayaan diri.',
      diagnosis:
          'Maloklusi klas I dengan crowding ringan pada regio anterior mandibula',
      treatment:
          'Konsultasi ortodonti dan pemasangan behel/kawat gigi (braces) pada rahang atas dan bawah',
      procedures: [
        'Pemeriksaan ortodonti lengkap',
        'Foto rontgen sefalometri dan panoramik',
        'Pencetakan model studi',
        'Analisis model dan foto',
        'Scaling dan pembersihan gigi',
        'Bonding bracket pada semua gigi',
        'Pemasangan archwire awal (0.014 NiTi)',
        'Instruksi perawatan behel',
      ],
      prescriptions: [
        Prescription(
          medicineName: 'Paracetamol 500mg',
          dosage: '1 tablet',
          frequency: 'Bila nyeri (maksimal 3x sehari)',
          duration: 5,
          notes: 'Untuk mengatasi rasa tidak nyaman awal pemasangan behel',
        ),
        Prescription(
          medicineName: 'Dental Wax (Malam Orthodontic)',
          dosage: 'Secukupnya',
          frequency: 'Bila diperlukan',
          duration: 30,
          notes:
              'Ditempelkan pada bracket yang mengganggu atau melukai pipi/bibir',
        ),
        Prescription(
          medicineName: 'Orthodontic Toothbrush (Sikat Gigi Khusus)',
          dosage: 'Secukupnya',
          frequency: '3x sehari setelah makan',
          duration: 730,
          notes:
              'Sikat gigi dengan teknik khusus untuk pembersihan sekitar bracket',
        ),
      ],
      notes:
          'Estimasi waktu perawatan ortodonti 18-24 bulan. Pasien dijadwalkan kontrol rutin setiap 4 minggu untuk penggantian karet dan penyesuaian kawat. Hindari makanan keras, lengket, dan mengunyah es. Jaga kebersihan mulut dengan menyikat gigi setiap setelah makan. Estimasi biaya total perawatan Rp 15.000.000 (sudah termasuk kontrol rutin).',
      totalCost: 2500000,
      status: 'in-progress',
      vitalSigns: VitalSigns(
        bloodPressure: '115/75',
        heartRate: 70,
        temperature: 36.6,
        weight: 52,
        height: 162,
      ),
    ),
    MedicalRecord(
      id: 'MR007',
      patientName: 'Fajar Ramadhan',
      patientId: 'P007',
      visitDate: DateTime(2024, 11, 10, 10, 15),
      doctorName: 'drg. Ahmad Fauzi, Sp.Ort',
      complaint:
          'Gigi bungsu kanan atas tumbuh miring dan sering menyebabkan pipi tergigit. Nyeri hilang timbul.',
      diagnosis:
          'Impaksi parsial gigi 18 (molar ketiga kanan atas) posisi horizontal dengan trauma pada mukosa bukal',
      treatment:
          'Odontektomi (pencabutan gigi bungsu impaksi) dengan teknik bedah',
      procedures: [
        'Pemeriksaan klinis dan foto rontgen panoramik',
        'Anestesi lokal infiltrasi',
        'Insisi dan elevasi flap mukoperiosteal',
        'Pengambilan tulang dengan bur',
        'Seksionering mahkota dan akar gigi',
        'Ekstraksi gigi dengan elevator dan tang',
        'Irigasi socket dengan saline steril',
        'Penjahitan luka dengan silk 3.0',
      ],
      prescriptions: [
        Prescription(
          medicineName: 'Amoxicillin 500mg',
          dosage: '1 kapsul',
          frequency: '3x sehari setelah makan',
          duration: 5,
          notes: 'Antibiotik profilaksis, harus dihabiskan',
        ),
        Prescription(
          medicineName: 'Asam Mefenamat 500mg',
          dosage: '1 tablet',
          frequency: '3x sehari setelah makan',
          duration: 5,
          notes: 'Untuk mengurangi nyeri dan inflamasi pasca operasi',
        ),
        Prescription(
          medicineName: 'Dexamethasone 0.5mg',
          dosage: '1 tablet',
          frequency: '3x sehari setelah makan (tappering off)',
          duration: 3,
          notes: 'Untuk mengurangi pembengkakan',
        ),
        Prescription(
          medicineName: 'Chlorhexidine Gluconate 0.2% (Obat Kumur)',
          dosage: '10-15 ml',
          frequency: '2x sehari',
          duration: 7,
          notes: 'Berkumur perlahan, jangan berkumur terlalu keras',
        ),
      ],
      notes:
          'Pasien diinstruksikan untuk kompres dingin 24 jam pertama, kemudian kompres hangat. Makan makanan lunak dan dingin. Tidur dengan posisi kepala lebih tinggi. Jangan berkumur keras atau menyedot area operasi. Jahitan dibuka 7 hari kemudian. Segera ke klinik jika terjadi perdarahan hebat, demam tinggi, atau pembengkakan berlebihan.',
      totalCost: 1800000,
      status: 'completed',
      vitalSigns: VitalSigns(
        bloodPressure: '128/82',
        heartRate: 80,
        temperature: 36.8,
        weight: 78,
        height: 175,
      ),
    ),
  ];

  // Method untuk mendapatkan semua rekam medis
  List<MedicalRecord> getAllMedicalRecords() {
    return List.from(_medicalRecords);
  }

  // Method untuk mendapatkan rekam medis berdasarkan ID
  MedicalRecord? getMedicalRecordById(String id) {
    try {
      return _medicalRecords.firstWhere((record) => record.id == id);
    } catch (e) {
      return null;
    }
  }

  // Method untuk mendapatkan rekam medis berdasarkan patient ID
  List<MedicalRecord> getMedicalRecordsByPatientId(String patientId) {
    return _medicalRecords
        .where((record) => record.patientId == patientId)
        .toList();
  }

  // Method untuk mendapatkan rekam medis berdasarkan status
  List<MedicalRecord> getMedicalRecordsByStatus(String status) {
    return _medicalRecords.where((record) => record.status == status).toList();
  }

  // Method untuk mendapatkan rekam medis terbaru (sorted by date)
  List<MedicalRecord> getRecentMedicalRecords({int limit = 5}) {
    final sorted = List<MedicalRecord>.from(_medicalRecords)
      ..sort((a, b) => b.visitDate.compareTo(a.visitDate));
    return sorted.take(limit).toList();
  }

  // Method untuk menambah rekam medis baru
  void addMedicalRecord(MedicalRecord record) {
    _medicalRecords.add(record);
  }

  // Method untuk update rekam medis
  bool updateMedicalRecord(String id, MedicalRecord updatedRecord) {
    final index = _medicalRecords.indexWhere((record) => record.id == id);
    if (index != -1) {
      _medicalRecords[index] = updatedRecord;
      return true;
    }
    return false;
  }

  // Method untuk delete rekam medis
  bool deleteMedicalRecord(String id) {
    final initialLength = _medicalRecords.length;
    _medicalRecords.removeWhere((record) => record.id == id);
    return _medicalRecords.length < initialLength;
  }

  // Method untuk search rekam medis berdasarkan nama pasien
  List<MedicalRecord> searchMedicalRecordsByPatientName(String query) {
    return _medicalRecords
        .where(
          (record) =>
              record.patientName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  // Method untuk mendapatkan total rekam medis
  int getTotalMedicalRecords() {
    return _medicalRecords.length;
  }
}
