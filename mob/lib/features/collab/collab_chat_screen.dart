import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../design_system/theme_extensions.dart';
import '../auth/auth_provider.dart';
import 'collab_provider.dart';

class CollabChatScreen extends ConsumerStatefulWidget {
  final CollabProfileModel profile;
  const CollabChatScreen({super.key, required this.profile});

  @override
  ConsumerState<CollabChatScreen> createState() => _CollabChatScreenState();
}

class _CollabChatScreenState extends ConsumerState<CollabChatScreen> {
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();

  Future<void> _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    _msgController.clear();

    try {
      await ref.read(collabServiceProvider).insertMessagePacket(
            senderId: currentUser.id,
            recipientId: widget.profile.id,
            text: text,
          );
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: Text('PACKET_DROP_ERR: ${e.toString()}')),
        );
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatStreamProvider(widget.profile.id));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: context.terminalColors.neutralBg,
      appBar: AppBar(
        backgroundColor: context.terminalColors.neutralBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '// channel: ${widget.profile.displayName}',
          style: TextStyle(
            fontFamily: 'JetBrains Mono', 
            color: context.terminalColors.primary, 
            fontSize: 16, 
            fontWeight: FontWeight.bold
          ),
        ),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(color: Color(0xFF21262D), height: 1)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: chatAsync.when(
                data: (chatHistory) {
                  if (chatHistory.isEmpty) {
                    return const Center(
                      child: Text(
                        'SECURE_CHANNEL_INITIALIZED\nAwaiting sequence transmissions...',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'JetBrains Mono', color: Color(0xFF8B949E), fontSize: 13, height: 1.4),
                      ),
                    );
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatHistory.length,
                    itemBuilder: (context, idx) {
                      final msg = chatHistory[idx];
                      final isMe = msg.senderId == currentUser?.id;
                      final timeStr = DateFormat('HH:mm').format(msg.timestamp);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isMe ? const Color(0xFF161B22) : const Color(0xFF0D1117),
                              border: Border.all(color: isMe ? context.terminalColors.primary.withValues(alpha: 0.3) : const Color(0xFF21262D)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isMe ? 'me_' : '${widget.profile.displayName}_',
                                      style: TextStyle(
                                        fontFamily: 'JetBrains Mono', 
                                        fontSize: 11, 
                                        fontWeight: FontWeight.bold, 
                                        color: isMe ? context.terminalColors.primary : const Color(0xFFFFBD2E)
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(timeStr, style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, color: Color(0xFF8B949E))),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  msg.text,
                                  style: const TextStyle(fontFamily: 'JetBrains Mono', color: Color(0xFFC9D1D9), fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF39D353))),
                error: (err, stack) => Center(
                  child: Text('LOG_STREAM_EXCEPTION: $err', style: const TextStyle(fontFamily: 'JetBrains Mono', color: Colors.redAccent)),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Color(0xFF001117), border: Border(top: BorderSide(color: Color(0xFF21262D)))),
              child: Row(
                children: [
                  Text('\$ ', style: TextStyle(fontFamily: 'JetBrains Mono', color: context.terminalColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      style: const TextStyle(fontFamily: 'JetBrains Mono', color: Colors.white, fontSize: 14),
                      cursorColor: context.terminalColors.primary,
                      decoration: const InputDecoration(
                        hintText: 'transmit_packet_data...',
                        hintStyle: TextStyle(color: Color(0xFF8B949E), fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 4),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send_rounded, color: context.terminalColors.primary, size: 20),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}