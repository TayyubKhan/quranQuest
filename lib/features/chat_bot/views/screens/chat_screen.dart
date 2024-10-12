import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:quranquest/core/go_router/router.dart';
import 'package:quranquest/features/chat_bot/widgets/MarkDownSheet.dart';

import '../../../../core/themes/color_scheme.dart';
import '../../ChatViewModel/ChatViewModel.dart';
import '../../models/chat_model.dart';
import '../../repositories/chat_repository.dart';
import '../../widgets/AppDrawer.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatNotifier = ref.read(chatNotifierProvider.notifier);
      if (chatNotifier.currentChatId != null) {
        chatNotifier.loadMessages(
            chatNotifier.currentChatId!); // Load messages for the current chat
      }
    });
    // Add listener to detect changes in scroll position and trigger actions
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
        } else {}
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  final TextEditingController _textController = TextEditingController();
  final ChatRepository _chatRepository = ChatRepository();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    super.build(context);
    final chatMessages = ref.watch(chatNotifierProvider);

    // Delay scroll after a message is added
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: darkColor),
        title: const Text('Quran Quest',
            style: TextStyle(color: Color(0xff004d40))),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () async {
                log('User is trying to sign out.');
                final auth = FirebaseAuth.instance;
                try {
                  // Check if the platform is web
                  if (kIsWeb) {
                    // Set persistence to NONE before signing out
                    await auth.setPersistence(Persistence.NONE);
                  }
                  // Sign out the user
                  await auth.signOut();

                  // Invalidate the chat provider
                  ref.invalidate(chatNotifierProvider);
                  // Redirect to the sign-in page
                  AppRouter.router.go(RouteTo.signIn);
                } catch (error) {
                  log('Error during sign out: $error');
                  // You can also show an error message to the user if needed
                }
              },
              child: Icon(Icons.exit_to_app, color: darkColor),
            ),
          ),
        ],
      ),
      drawer: const ChatDrawer(),
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.2, // Optional: Semi-transparent background image
              child: Image.asset(
                kIsWeb ? 'call.png' : 'assets/call.png',
                fit: BoxFit.contain,
                colorBlendMode: BlendMode.difference,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RepaintBoundary(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: chatMessages.length,
                      itemBuilder: (context, index) {
                        final element = chatMessages[index];
                        bool isUser = element.fromUser;
                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isUser ? lightColor : darkColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: isUser
                                      ? const Radius.circular(12)
                                      : Radius.zero,
                                  topRight: isUser
                                      ? Radius.zero
                                      : const Radius.circular(12),
                                  bottomLeft: const Radius.circular(12),
                                  bottomRight: const Radius.circular(12),
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.65,
                              ),
                              child: Column(
                                crossAxisAlignment: isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  MarkdownBody(
                                    selectable: true,
                                    data: element.text,
                                    styleSheet: markdownStyleSheet(isUser),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width * .8),
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 18),
                        child: TextField(
                          style: GoogleFonts.nunito(color: darkColor),
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: 'Start your quest...',
                            filled: true,
                            fillColor: darkColor.withOpacity(0.2),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: Consumer(builder: (context, ref, _) {
                              return !ref.watch(isLoadingProvider)
                                  ? InkWell(
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        await sendChatMessage(
                                            _textController.text);
                                        _scrollToBottom();
                                      },
                                      child: Icon(
                                        Icons.send,
                                        color: darkColor,
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(12),
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: darkColor,
                                      ),
                                    );
                            }),
                          ),
                          onSubmitted: (value) {
                            sendChatMessage(_textController.text);
                          },
                          cursorColor: darkColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendChatMessage(String message) async {
    if (message.isNotEmpty) {
      ref.read(isLoadingProvider.notifier).state = true;
      final chatNotifier = ref.read(chatNotifierProvider.notifier);
      _textController.clear();
      await chatNotifier.sendMessage(message, fromUser: true);

      await Future.delayed(
          const Duration(milliseconds: 300)); // Allow time for rendering
      _scrollToBottom();

      await Future.delayed(const Duration(seconds: 2));

      final aiResponse = await _chatRepository.sendChatMessage(message);

      if (aiResponse != null) {
        await chatNotifier.sendMessage(aiResponse, fromUser: false);
      }

      ref.read(isLoadingProvider.notifier).state = false;
      await Future.delayed(
          const Duration(milliseconds: 300)); // Give time to load response
      _scrollToBottom();
    } else {
      print('error');
    }
  }
}

final isLoadingProvider = StateProvider<bool>((ref) => false);
