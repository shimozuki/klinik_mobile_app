import 'package:klinik/models/ChatModel.dart';

class ChatService {
  // Dummy data untuk chat rooms
  static List<ChatRoom> getChatRooms() {
    return [
      ChatRoom(
        id: '1',
        doctorId: 'doc1',
        doctorName: 'drg. Bambang Suryanto, Sp.BM',
        doctorSpecialty: 'Spesialis Bedah Mulut',
        doctorImageUrl: 'https://via.placeholder.com/150',
        patientId: 'patient1',
        patientName: 'Budi Santoso',
        lastMessage: ChatMessage(
          id: 'msg1',
          senderId: 'doc1',
          senderName: 'drg. Bambang Suryanto',
          senderRole: 'doctor',
          message: 'Baik, silakan konsumsi obat sesuai resep ya',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          isRead: false,
        ),
        unreadCount: 2,
        isOnline: true,
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ChatRoom(
        id: '2',
        doctorId: 'doc2',
        doctorName: 'Dr. Sarah Wijaya, Sp.PD',
        doctorSpecialty: 'Spesialis Penyakit Dalam',
        doctorImageUrl: 'https://via.placeholder.com/150',
        patientId: 'patient1',
        patientName: 'Budi Santoso',
        lastMessage: ChatMessage(
          id: 'msg2',
          senderId: 'patient1',
          senderName: 'Budi Santoso',
          senderRole: 'patient',
          message: 'Terima kasih dokter',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isRead: true,
        ),
        unreadCount: 0,
        isOnline: false,
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ChatRoom(
        id: '3',
        doctorId: 'doc3',
        doctorName: 'Dr. Ahmad Fauzi, Sp.A',
        doctorSpecialty: 'Spesialis Anak',
        doctorImageUrl: 'https://via.placeholder.com/150',
        patientId: 'patient1',
        patientName: 'Budi Santoso',
        lastMessage: ChatMessage(
          id: 'msg3',
          senderId: 'patient1',
          senderName: 'Budi Santoso',
          senderRole: 'patient',
          message: 'Baik dok, saya akan ke klinik besok',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
        ),
        unreadCount: 0,
        isOnline: false,
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }

  // Dummy data untuk messages dalam chat room
  static List<ChatMessage> getMessages(String chatRoomId) {
    // Return different messages based on chatRoomId
    if (chatRoomId == '1') {
      return [
        ChatMessage(
          id: 'msg1',
          senderId: 'patient1',
          senderName: 'Budi Santoso',
          senderRole: 'patient',
          message: 'Selamat pagi dokter, saya ingin berkonsultasi',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg2',
          senderId: 'doc1',
          senderName: 'drg. Bambang Suryanto',
          senderRole: 'doctor',
          message: 'Selamat pagi. Silakan, ada yang bisa saya bantu?',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 2, minutes: -5),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg3',
          senderId: 'patient1',
          senderName: 'Budi Santoso',
          senderRole: 'patient',
          message:
              'Gigi geraham saya sakit sekali dok, sudah 2 hari ini. Apa yang harus saya lakukan?',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 50),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg4',
          senderId: 'doc1',
          senderName: 'drg. Bambang Suryanto',
          senderRole: 'doctor',
          message:
              'Baik, saya pahami keluhannya. Apakah ada pembengkakan di area gigi yang sakit?',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 45),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg5',
          senderId: 'patient1',
          senderName: 'Budi Santoso',
          senderRole: 'patient',
          message: 'Iya dok, sedikit bengkak dan nyeri kalau untuk makan',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 40),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg6',
          senderId: 'doc1',
          senderName: 'drg. Bambang Suryanto',
          senderRole: 'doctor',
          message:
              'Kemungkinan ada infeksi pada gigi. Saya sarankan untuk:\n\n1. Konsumsi obat pereda nyeri seperti paracetamol\n2. Berkumur dengan air garam hangat\n3. Hindari makanan yang terlalu panas/dingin\n4. Segera datang ke klinik untuk pemeriksaan lebih lanjut',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 30),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg7',
          senderId: 'patient1',
          senderName: 'Budi Santoso',
          senderRole: 'patient',
          message:
              'Baik dokter, terima kasih sarannya. Kapan saya bisa datang ke klinik?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg8',
          senderId: 'doc1',
          senderName: 'drg. Bambang Suryanto',
          senderRole: 'doctor',
          message:
              'Baik, silakan konsumsi obat sesuai resep ya. Untuk jadwal kunjungan, bisa besok pagi jam 09.00. Apakah bisa?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          isRead: false,
        ),
      ];
    } else if (chatRoomId == '2') {
      return [
        ChatMessage(
          id: 'msg1',
          senderId: 'patient1',
          senderName: 'Budi Santoso',
          senderRole: 'patient',
          message: 'Selamat siang dokter',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg2',
          senderId: 'doc2',
          senderName: 'Dr. Sarah Wijaya',
          senderRole: 'doctor',
          message: 'Selamat siang, ada yang bisa dibantu?',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 3, minutes: 55),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg3',
          senderId: 'patient1',
          senderName: 'Budi Santoso',
          senderRole: 'patient',
          message: 'Saya mau tanya hasil lab kemarin dok',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 3, minutes: 50),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg4',
          senderId: 'doc2',
          senderName: 'Dr. Sarah Wijaya',
          senderRole: 'doctor',
          message:
              'Hasil lab Anda sudah keluar dan semuanya dalam batas normal. Tidak ada yang perlu dikhawatirkan.',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 3, minutes: 40),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg5',
          senderId: 'patient1',
          senderName: 'Budi Santoso',
          senderRole: 'patient',
          message: 'Terima kasih dokter',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isRead: true,
        ),
      ];
    } else {
      return [
        ChatMessage(
          id: 'msg1',
          senderId: 'patient1',
          senderName: 'Budi Santoso',
          senderRole: 'patient',
          message: 'Dokter, saya mau konsultasi tentang anak saya',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg2',
          senderId: 'doc3',
          senderName: 'Dr. Ahmad Fauzi',
          senderRole: 'doctor',
          message: 'Baik, silakan. Anak Anda umur berapa?',
          timestamp: DateTime.now().subtract(
            const Duration(days: 1, hours: 1, minutes: 55),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg3',
          senderId: 'patient1',
          senderName: 'Budi Santoso',
          senderRole: 'patient',
          message: 'Usia 5 tahun dok. Dia demam sejak 2 hari yang lalu',
          timestamp: DateTime.now().subtract(
            const Duration(days: 1, hours: 1, minutes: 50),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg4',
          senderId: 'doc3',
          senderName: 'Dr. Ahmad Fauzi',
          senderRole: 'doctor',
          message:
              'Berapa derajat demamnya? Dan apakah ada gejala lain seperti batuk atau pilek?',
          timestamp: DateTime.now().subtract(
            const Duration(days: 1, hours: 1, minutes: 45),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg5',
          senderId: 'patient1',
          senderName: 'Budi Santoso',
          senderRole: 'patient',
          message: 'Sekitar 38 derajat dok. Ada batuk sedikit',
          timestamp: DateTime.now().subtract(
            const Duration(days: 1, hours: 1, minutes: 40),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg6',
          senderId: 'doc3',
          senderName: 'Dr. Ahmad Fauzi',
          senderRole: 'doctor',
          message:
              'Untuk sementara berikan paracetamol sesuai dosis anak. Banyak minum air putih dan istirahat yang cukup. Jika demam tidak turun dalam 3 hari, sebaiknya dibawa ke klinik ya.',
          timestamp: DateTime.now().subtract(
            const Duration(days: 1, hours: 1, minutes: 30),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg7',
          senderId: 'patient1',
          senderName: 'Budi Santoso',
          senderRole: 'patient',
          message: 'Baik dok, saya akan ke klinik besok',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
        ),
      ];
    }
  }

  // Fungsi untuk mengirim pesan (simulasi)
  static Future<ChatMessage> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String senderName,
    required String senderRole,
    required String message,
  }) async {
    // Simulasi delay network
    await Future.delayed(const Duration(milliseconds: 500));

    return ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      senderName: senderName,
      senderRole: senderRole,
      message: message,
      timestamp: DateTime.now(),
      isRead: false,
    );
  }

  // Fungsi untuk mendapatkan chat room berdasarkan ID
  static ChatRoom? getChatRoomById(String chatRoomId) {
    try {
      return getChatRooms().firstWhere((room) => room.id == chatRoomId);
    } catch (e) {
      return null;
    }
  }

  // Fungsi untuk mark as read (simulasi)
  static Future<void> markAsRead(String chatRoomId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, this would update the database
  }
}
