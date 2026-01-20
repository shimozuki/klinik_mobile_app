import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:klinik/config/ApiConfig.dart';
import 'package:klinik/content/ChatBubbleComponent.dart';
import 'package:klinik/models/ChatMessageModel.dart';
import 'package:klinik/models/ChatModel.dart';
import 'package:klinik/service/AuthLocalStorage.dart';
import 'package:klinik/service/ChatifyRepository.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ChatRoomPage extends StatefulWidget {
  final int userId;
  final String userName;

  const ChatRoomPage({Key? key, required this.userId, required this.userName})
    : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessageModel> messages = [];
  bool isLoading = true;
  bool isSending = false;
  PusherChannelsFlutter? pusher;
  late int myUserId;

  static String baseUrl = ApiConfig.baseUrl;
  Timer? _pollingTimer;

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      _loadMessages(silent: true); // 🚫 TIDAK ADA LOADING
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
    _loadMessages();
  }

  Future<void> _init() async {
    await _loadMessages();
    await _initPusher();
    _startPolling();
  }

  Future<void> _initPusher() async {
    // ✅ Cek mounted sebelum init
    if (!mounted) return;

    pusher = PusherChannelsFlutter.getInstance();

    try {
      await pusher!.init(
        apiKey: '7845f41408ddc1cfd065',
        cluster: 'ap1',
        authEndpoint: '$baseUrl/chat/auth',
        onConnectionStateChange: (currentState, previousState) {
          print('🔌 Pusher State Changed: $previousState -> $currentState');
        },
        onError: (message, code, error) {
          print('❌ Pusher Error: $message (code: $code)');
        },
        onEvent: (event) {
          // ✅ CRITICAL: Cek mounted DI AWAL
          if (!mounted) {
            print('⚠️ Widget not mounted, ignoring event');
            return;
          }

          print('📨 Event: ${event.eventName}');
          print('📦 Data: ${event.data}');

          if (event.eventName == 'messaging') {
            try {
              final data = jsonDecode(event.data);
              final message = data['message'];

              // ✅ Cek mounted sebelum setState
              if (!mounted) {
                print('⚠️ Widget not mounted before setState');
                return;
              }

              setState(() {
                messages.add(ChatMessageModel.fromChatify(message, myUserId));
              });

              _scrollToBottom();
              print('✅ Message added');
            } catch (e) {
              print('❌ Error parsing: $e');
            }
          }
        },
      );

      print('👤 My User ID: $myUserId');
      print('📡 Subscribing to: private-chatify.$myUserId');

      await pusher!.subscribe(channelName: 'private-chatify.$myUserId');
      await pusher!.connect();

      print('✅ Pusher connected');
    } catch (e) {
      print('❌ Error init Pusher: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null) return;

    final token = await AuthLocalStorage.getToken();
    if (token == null) return;

    setState(() => isSending = true);

    try {
      await ChatifyRepository().sendImage(
        token: token,
        toId: widget.userId,
        image: File(picked.path),
      );

      await _loadMessages(silent: true);
    } catch (e) {
      debugPrint('UPLOAD ERROR: $e');
    } finally {
      if (mounted) setState(() => isSending = false);
    }
  }

  @override
  void dispose() {
    _disconnectPusher();
    _pollingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _disconnectPusher() {
    try {
      if (pusher != null) {
        pusher!.unsubscribe(channelName: 'private-chatify.$myUserId');
        pusher!.disconnect();
        pusher = null; // ✅ Set null setelah disconnect
        print('✅ Pusher disconnected');
      }
    } catch (e) {
      print('❌ Error disconnecting Pusher: $e');
    }
  }

  // void _loadMessages() {
  //   setState(() {
  //     isLoading = true;
  //   });

  Future<void> _loadMessages({bool silent = false}) async {
    if (!silent) {
      setState(() => isLoading = true);
    }

    final token = await AuthLocalStorage.getToken();
    final user = await AuthLocalStorage.getUser();

    if (token == null || user == null) return;

    myUserId = user.id;

    final data = await ChatifyRepository().fetchMessages(
      token: token,
      withUserId: widget.userId,
    );

    if (!mounted) return;

    setState(() {
      messages =
          data
              .map<ChatMessageModel>(
                (e) => ChatMessageModel.fromChatify(e, myUserId),
              )
              .toList();

      if (!silent) isLoading = false;
    });

    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final text = _messageController.text.trim();
    _messageController.clear();

    setState(() => isSending = true);

    try {
      final token = await AuthLocalStorage.getToken();

      await ChatifyRepository().sendMessage(
        token: token!,
        toId: widget.userId,
        message: text,
      );

      // 🔥 PENTING: jangan pakai loading
      await _loadMessages(silent: true);
    } catch (e) {
      print('error $e');
      // if (mounted) {
      //   ScaffoldMessenger.of(
      //     context,
      //   ).showSnackBar(const SnackBar(content: Text('Gagal mengirim pesan')));
      // }
    } finally {
      if (mounted) {
        setState(() => isSending = false);
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: isLoading ? _buildLoadingState() : _buildMessageList(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 24),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // const SizedBox(height: 2),
                // Row(
                //   children: [
                //     if (widget.chatRoom.isOnline) ...[
                //       Container(
                //         width: 6,
                //         height: 6,
                //         decoration: const BoxDecoration(
                //           color: Color(0xFF4CAF50),
                //           shape: BoxShape.circle,
                //         ),
                //       ),
                //       const SizedBox(width: 6),
                //     ],
                //     Flexible(
                //       child: Text(
                //         widget.chatRoom.isOnline
                //             ? 'Online'
                //             : widget.chatRoom.doctorSpecialty,
                //         style: TextStyle(
                //           fontSize: 12,
                //           color: Colors.white.withOpacity(0.9),
                //         ),
                //         maxLines: 1,
                //         overflow: TextOverflow.ellipsis,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     // Show options menu
          //     _showOptionsMenu();
          //   },
          //   icon: const Icon(Icons.more_vert, color: Colors.white),
          // ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
      ),
    );
  }

  Widget _buildMessageList() {
    if (messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isFromCurrentUser = message.isSender;

        // Check if we need to show date divider
        bool showDateDivider = false;
        if (index == 0) {
          showDateDivider = true;
        } else {
          final previousMessage = messages[index - 1];
          if (message.formattedDate != previousMessage.formattedDate) {
            showDateDivider = true;
          }
        }

        return Column(
          children: [
            if (showDateDivider) DateDivider(date: message.formattedDate),
            ChatBubble(message: message, isFromCurrentUser: isFromCurrentUser),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Mulai percakapan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kirim pesan untuk memulai konsultasi',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Tulis pesan...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF95A5A6),
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  IconButton(
                    onPressed: isSending ? null : _pickImage,
                    icon: const Icon(
                      Icons.attach_file_rounded,
                      color: Color(0xFF95A5A6),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isSending ? null : _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child:
                  isSending
                      ? const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      )
                      : const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionItem(Icons.info_outline_rounded, 'Info Dokter', () {
                Navigator.pop(context);
              }),
              _buildOptionItem(
                Icons.file_copy_outlined,
                'Lihat Rekam Medis',
                () {
                  Navigator.pop(context);
                },
              ),
              _buildOptionItem(
                Icons.calendar_today_rounded,
                'Buat Janji Temu',
                () {
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 32),
              _buildOptionItem(Icons.close_rounded, 'Tutup Konsultasi', () {
                Navigator.pop(context);
              }, isDestructive: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : const Color(0xFF4A90E2),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: isDestructive ? Colors.red : const Color(0xFF2C3E50),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
