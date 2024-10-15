import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quranquest/core/go_router/router.dart';
import 'package:quranquest/features/chat_bot/widgets/MarkDownSheet.dart';

import '../../../../core/themes/color_scheme.dart';
import '../../ChatViewModel/ChatViewModel.dart';
import '../../repositories/chat_repository.dart';
import '../../widgets/AppDrawer.dart';
import 'dart:html' show window;

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
  ChatRepository? _chatRepository;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    super.build(context);
    final chatMessages = ref.watch(chatNotifierProvider);
    // Delay scroll after a message is added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      _chatRepository = ChatRepository(ref);
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: darkColor),
          title: Image.asset(
            kIsWeb ? 'logo.png' : 'assets/logo.png',
            width: width * 0.04,
          ),
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
                  child: Text('Logout',
                      style:
                          GoogleFonts.nunito(color: const Color(0xff004d40)))),
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
                                  color: isUser
                                      ? lightColor.withOpacity(0.8)
                                      : darkColor.withOpacity(0.8),
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
                    ref.watch(topicProvider).isNotEmpty ||
                            ref.watch(generalProvider)
                        ? ConstrainedBox(
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
                                    suffixIcon:
                                        Consumer(builder: (context, ref, _) {
                                      return !ref.watch(isLoadingProvider)
                                          ? InkWell(
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
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
                          )
                        : SizedBox(
                            width: width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildListItem(context, 'Prayer'),
                                buildListItem(context, 'Quranic Verses'),
                                buildListItem(context, 'Hadith'),
                                buildListItem(context, 'Zakat'),
                                buildListItem(context, 'Islamic Etiquettes'),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

      final aiResponse = await _chatRepository?.sendChatMessage(message);

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

  Widget buildListItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        width: kIsWeb ? 400 : double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, // You can change the color as needed
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18.0,
                color: darkColor, // Use darkColor for the text
              ),
            ),
            InkWell(
              onTap: () async {
                ref.read(isLoadingProvider.notifier).state = true;
                final chatNotifier = ref.read(chatNotifierProvider.notifier);
                updateTopicProvider(ref, text);
                final message =
                    await _chatRepository?.sendChatMessage("Who are you?");
               await chatNotifier.sendMessage(message!, fromUser: false);
                ref.read(isLoadingProvider.notifier).state = false;

              },
              child: Icon(
                Icons.send,
                color: darkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final isLoadingProvider = StateProvider<bool>((ref) => false);

final generalProvider = StateProvider<bool>((ref) {
  final value = window.localStorage['generalProvider'];
  return value == 'true';
});

// Update function to change value and store it in localStorage
void updateGeneralProvider(WidgetRef ref, bool newValue) {
  // Update the provider state
  ref.read(generalProvider.notifier).state = newValue;

  // Save the new value in localStorage
  window.localStorage['generalProvider'] =
      newValue.toString(); // Convert bool to string
}

final topicProvider = StateProvider<String>((ref) {
  return window.localStorage['topicProvider'] ?? ''; // Default to empty string
});

// Update function to change value and store it in localStorage
void updateTopicProvider(WidgetRef ref, String newValue) {
  // Update the provider state
  ref.read(topicProvider.notifier).state = newValue;

  // Save the new value in localStorage
  window.localStorage['topicProvider'] = newValue; // Store string value
}
