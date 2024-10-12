import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for database interactions
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth for authentication
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod for state management

import '../models/chat_model.dart'; // Import the ChatMessage model
import '../repositories/chat_repository.dart'; // Import the chat repository for chat-related operations

// Define a StateNotifierProvider to manage the state of chat messages
final chatNotifierProvider =
StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier(ref); // Create a new instance of ChatNotifier
});

// ChatNotifier to manage chat messages and interactions
class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  final FirebaseAuth _auth = FirebaseAuth.instance; // Auth instance
  String? currentChatId; // Holds the current chat session ID
  final Ref _ref; // Store the ref for accessing other providers

  ChatNotifier(this._ref) : super([]); // Initialize with an empty chat message list

  // Get the current user ID from Firebase Auth
  String get userId {
    final user = _auth.currentUser; // Fetch the currently authenticated user
    if (user == null) throw Exception("User not authenticated"); // Throw exception if not authenticated
    return user.uid; // Return the user ID
  }

  // Function to load all chats for the user (for the drawer history)
  Future<List<Map<String, String>>> loadChats() async {
    try {
      // Fetch all chats for the user from Firestore
      final querySnapshot = await _firestore
          .collection('chats')
          .where('userId', isEqualTo: userId)
          .get();

      // Map each document to a Map containing chat ID and title
      final chatList = querySnapshot.docs.map((doc) {
        final data = doc.data(); // Get data from the document
        final chatId = doc.id; // Get the document ID (chat ID)
        final chatTitle =
        data.containsKey('title') ? data['title'] as String : 'No Title'; // Get chat title

        return {'id': chatId, 'title': chatTitle}; // Return chat ID and title
      }).toList();

      return chatList; // Return the list of chats
    } catch (e) {
      print("Error loading chats: $e"); // Print error message
      return []; // Return an empty list in case of error
    }
  }

  // Set the current chat ID manually
  void setCurrentChatId(String chatId) {
    currentChatId = chatId; // Assign the current chat ID
  }

  // Load messages for the specified chat ID
  Future<void> loadMessages(String chatId) async {
    try {
      currentChatId = chatId; // Update the current chat session
      state = []; // Clear previous messages if needed

      // Fetch the chat document from Firestore
      final chatDocSnapshot =
      await _firestore.collection('chats').doc(chatId).get();

      if (chatDocSnapshot.exists) { // Check if the chat document exists
        // Extract the messages from the chat document
        final chatData = chatDocSnapshot.data();

        if (chatData != null && chatData.containsKey('messages')) {
          // Convert message data to List of ChatMessage
          final messages = (chatData['messages'] as List).map((messageData) {
            return ChatMessage.fromMap(messageData as Map<String, dynamic>); // Map to ChatMessage
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
    if (message.isEmpty) return; // Do nothing if message is empty

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
          return messageMap['fromUser'] == false; // Filter AI messages
        }).toList();

        // If AI messages already exist, it's not the first AI message
        firstAiMessage = aiMessages.isEmpty; // Determine if it's the first AI message
      }

      // Prepare the new message (whether from user or AI)
      final chatMessage = ChatMessage(
        text: message,
        fromUser: fromUser, // Indicate if the message is from the user or AI
        timestamp: DateTime.now(), // Set the current timestamp
      );

      // Add the new message to Firestore
      await _firestore.collection('chats').doc(currentChatId).update({
        'messages': FieldValue.arrayUnion([chatMessage.toMap()]), // Add message to array
      });

      // Update the local state with the new message
      state = [...state, chatMessage]; // Append new message to the state

      // If this is an AI message and it's the first one, update the title
      if (!fromUser && firstAiMessage) {
        // Truncate the message if it's longer than 20 characters
        String? newTitle =
        await SummaryChatRepository().sendChatMessage(chatMessage.text);

        // Update the chat title in Firestore
        await _firestore.collection('chats').doc(currentChatId).update({
          'title': newTitle, // Update chat title
        });

        print("Updated chat title to: $newTitle");
      }
    } catch (e) {
      throw Exception("Failed to send message or process response: $e"); // Throw an exception on error
    }
  }

  // Create a new chat session in Firestore
  Future<String> _createNewChat() async {
    final newChatRef = await _firestore.collection('chats').add({
      'userId': userId, // Associate the chat with the current user
      'createdAt': FieldValue.serverTimestamp(), // Set the creation timestamp
      'title': 'New Chat', // Default title
      'messages': [], // Empty messages list initially
    });
    return newChatRef.id; // Return the new chat ID
  }

  // Handle new chat creation from UI
  Future<String> createNewChat() async {
    currentChatId = await _createNewChat(); // Create and assign new chat ID
    state = []; // Clear messages for the new chat
    return currentChatId!; // Return the new chat ID
  }

  // Reset the chat session (useful for logging out or invalidating)
  void resetChat() {
    currentChatId = null; // Clear current chat ID
    state = []; // Clear messages
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
      throw Exception("Failed to delete chat: $e"); // Throw an exception on error
    }
  }
}
