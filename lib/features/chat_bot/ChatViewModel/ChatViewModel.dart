import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_model.dart';
import '../repositories/chat_repository.dart';

final chatNotifierProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier(ref);
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? currentChatId; // Holds the current chat session ID
  final Ref _ref; // Store the ref

  ChatNotifier(this._ref) : super([]);
  // Get the current user ID
  String get userId {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not authenticated");
    return user.uid;
  }

  // Function to load all chats (for the drawer history)
  Future<List<Map<String, String>>> loadChats() async {
    try {
      // Fetch all chats for the user
      final querySnapshot = await _firestore
          .collection('chats')
          .where('userId', isEqualTo: userId)
          .get();

      // Map each document to a Map containing chat ID and title
      final chatList = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final chatId = doc.id;
        final chatTitle =
            data.containsKey('title') ? data['title'] as String : 'No Title';

        return {'id': chatId, 'title': chatTitle};
      }).toList();

      return chatList;
    } catch (e) {
      print("Error loading chats: $e");
      return []; // Return an empty list in case of error
    }
  }

// Set the current chat ID manually
  void setCurrentChatId(String chatId) {
    currentChatId = chatId;
  }

  Future<void> loadMessages(String chatId) async {
    try {
      currentChatId = chatId; // Update the current chat session
      state = []; // Clear previous messages if needed
      // Fetch the chat document directly from Firestore
      final chatDocSnapshot =
          await _firestore.collection('chats').doc(chatId).get();

      if (chatDocSnapshot.exists) {
        // Extract the messages from the chat document
        final chatData = chatDocSnapshot.data();

        if (chatData != null && chatData.containsKey('messages')) {
          final messages = (chatData['messages'] as List).map((messageData) {
            return ChatMessage.fromMap(messageData as Map<String, dynamic>);
          }).toList();

          state = messages; // Update state with the loaded messages
        } else {
          state = []; // No messages found
        }
      } else {
        state = []; // No document found
      }
    } catch (e) {
      state = []; // Optionally clear the state on error
    }
  }

  // Send a message from the user and process the AI response
  Future<void> sendMessage(String message, {required bool fromUser}) async {
    if (message.isEmpty) return;

    try {
      // Create a new chat if no active chat exists
      currentChatId ??= await _createNewChat();

      // Fetch the current chat data before adding the new message
      final chatSnapshot =
          await _firestore.collection('chats').doc(currentChatId).get();
      final chatData = chatSnapshot.data();

      // Print the chat info for debugging
      print("Chat Data for chatId: $currentChatId");
      print("Chat Info: $chatData");

      // Check if it's the first AI message by fetching current chat messages
      bool firstAiMessage = true;
      if (chatData != null && chatData.containsKey('messages')) {
        final messages = chatData['messages'] as List;

        // Check for any existing AI messages before adding this one
        final aiMessages = messages.where((messageData) {
          final messageMap = messageData as Map<String, dynamic>;
          return messageMap['fromUser'] == false;
        }).toList();

        // If AI messages already exist, it's not the first AI message
        firstAiMessage = aiMessages.isEmpty;
      }

      // Prepare the new message (whether from user or AI)
      final chatMessage = ChatMessage(
        text: message,
        fromUser: fromUser,
        timestamp: DateTime.now(),
      );

      // Add the new message to Firestore
      await _firestore.collection('chats').doc(currentChatId).update({
        'messages': FieldValue.arrayUnion([chatMessage.toMap()]),
      });

      // Update the local state with the new message
      state = [...state, chatMessage];

      // If this is an AI message and it's the first one, update the title
      if (!fromUser && firstAiMessage) {
        // Truncate the message if it's longer than 20 characters
        String? newTitle =
            await SummaryChatRepository().sendChatMessage(chatMessage.text);

        // Update the chat title in Firestore
        await _firestore.collection('chats').doc(currentChatId).update({
          'title': newTitle,
        });

        print("Updated chat title to: $newTitle");
      }
    } catch (e) {
      throw Exception("Failed to send message or process response: $e");
    }
  }

  // Create a new chat session in Firestore
  Future<String> _createNewChat() async {
    final newChatRef = await _firestore.collection('chats').add({
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'title': 'New Chat', // Default title
      'messages': [], // Empty messages list initially
    });
    return newChatRef.id; // Return the new chat ID
  }

  // Handle new chat creation from UI
  Future<String> createNewChat() async {
    currentChatId = await _createNewChat(); // Create and assign new chat ID
    state = []; // Clear messages for the new chat
    return currentChatId!;
  }

  // Reset the chat session (useful for logging out or invalidating)
  void resetChat() {
    currentChatId = null;
    state = [];
  }

// Function to delete a chat by its ID
  Future<void> deleteChat(String chatId) async {
    try {
      // Remove the chat from Firestore
      await _firestore.collection('chats').doc(chatId).delete();

      // Optionally update the local state to remove messages related to the deleted chat
      // Since messages do not have a chatId, we will just reset the state
      if (currentChatId == chatId) {
        resetChat(); // Clear current chat messages if it's the one being deleted
      }

      print("Chat with ID $chatId deleted successfully.");
    } catch (e) {
      throw Exception("Failed to delete chat: $e");
    }
  }
}
