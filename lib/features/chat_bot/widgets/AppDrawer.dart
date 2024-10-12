import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quranquest/features/chat_bot/ChatViewModel/ChatViewModel.dart';
import '../../../../core/themes/color_scheme.dart';

class ChatDrawer extends ConsumerWidget {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatNotifier = ref.watch(chatNotifierProvider.notifier);
    final currentChatId = chatNotifier.currentChatId;

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 3,
      child: SafeArea(
        child: Column(
          children: [
            // Create a new chat button
            ListTile(
              leading: Icon(
                Icons.add,
                color: darkColor,
              ),
              title: Text(
                'New Quest',
                style: TextStyle(color: darkColor),
              ),
              onTap: () async {
                final newChatId = await chatNotifier.createNewChat();
                chatNotifier.setCurrentChatId(newChatId);
                Navigator.pop(context); // Close the drawer after creation
              },
            ),
            // Chat history section
            Expanded(
              child: FutureBuilder<List<Map<String, String>>>(
                // Fetch chat history
                future: chatNotifier.loadChats(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: darkColor,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading chats'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No chats available'));
                  }
                  final chatIds = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: chatIds.length,
                    itemBuilder: (context, index) {
                      final chatId = chatIds[index]['id']!;
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: currentChatId == chatId
                                ? darkColor
                                : Colors.transparent,
                          ),
                        ),
                        child: ListTile(
                          // Display chat summary for each chat
                          title: Text(
                            chatIds[index]['title'] ?? 'New Chat',
                            style: TextStyle(color: darkColor),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          onTap: () async {
                            chatNotifier.setCurrentChatId(chatId);
                            await chatNotifier.loadMessages(chatId);
                            Navigator.pop(context); // Close the drawer
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: darkColor),
                            onPressed: () async {
                              // Show confirmation dialog before deletion
                              final confirmDelete = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Chat'),
                                    content: const Text(
                                        'Are you sure you want to delete this chat?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          await chatNotifier.deleteChat(chatId);
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: darkColor),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: darkColor),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmDelete == true) {
                                // Delete the chat
                                await chatNotifier.deleteChat(chatId);
                                Navigator.pop(context); // Close the drawer
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
