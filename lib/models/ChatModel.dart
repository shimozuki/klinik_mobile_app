class ChatRoom {
  final int id;
  final String doctorName;
  final String doctorSpecialty;
  final bool isOnline;
  final int unreadCount;
  final String? lastMessage;

  ChatRoom({
    required this.id,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.isOnline,
    required this.unreadCount,
    this.lastMessage,
  });

  factory ChatRoom.fromChatify(Map<String, dynamic> json) {
    return ChatRoom(
      id: int.parse(json['id'].toString()), // ✅ FIX
      doctorName: json['name'] ?? '-',
      doctorSpecialty: 'Dokter Gigi',
      isOnline: json['active_status'].toString() == '1',
      unreadCount: int.parse(json['unread']?.toString() ?? '0'), // ✅ FIX
      lastMessage: null,
    );
  }
}
