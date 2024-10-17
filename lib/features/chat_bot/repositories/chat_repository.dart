import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/services.dart';
import 'package:quranquest/features/chat_bot/views/screens/chat_screen.dart';

import '../models/promptModel.dart';

/// A repository class for handling chat interactions with a generative AI model.
class ChatRepository {
  /// The generative AI model instance.
  late final GenerativeModel _model;

  /// The chat session for interacting with the AI model.
  late final ChatSession _chat;

  /// Creates an instance of [ChatRepository].
  ///
  /// Initializes the generative model with a specific model, API key, and system instruction.
  ChatRepository(WidgetRef ref) {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest', // Specifies the AI model to use
      apiKey:
          'AIzaSyApXkoBUzUlDmaLiQ-ltTe49NJqm5N1yxA', // API key for authentication
      systemInstruction:
          Content.text(generatePrompt()), // Instruction for the AI model
    );
    _chat = _model.startChat(); // Starts a new chat session
  }

  /// Sends a chat message to the AI model and retrieves the response.
  ///
  /// [message] is the text of the message to be sent.
  ///
  /// Returns the AI's response as a string, or null if an error occurs.
  Future<String?> sendChatMessage(String message) async {
    try {
      final response =
          await _chat.sendMessage(Content.text(message)); // Sends the message
      return response.text; // Returns the AI's response text
    } catch (e) {
      throw Exception(e.toString()); // Throws an exception if an error occurs
    }
  }
}

/// A repository class for handling summary-specific chat interactions with a generative AI model.
class SummaryChatRepository {
  /// The generative AI model instance for summaries.
  late final GenerativeModel _model;

  /// The chat session for interacting with the AI model.
  late final ChatSession _chat;

  /// Creates an instance of [SummaryChatRepository].
  ///
  /// Initializes the generative model with a specific model, API key, and a summary-specific system instruction.
  SummaryChatRepository() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest', // Specifies the AI model to use
      apiKey:
          'AIzaSyApXkoBUzUlDmaLiQ-ltTe49NJqm5N1yxA', // API key for authentication
      systemInstruction: Content.text(
          summaryPrompt), // Summary-specific instruction for the AI model
    );
    _chat = _model.startChat(); // Starts a new chat session
  }

  /// Sends a chat message to the AI model and retrieves a summary of the response.
  ///
  /// [message] is the text of the message to be sent.
  ///
  /// Returns the generated summary as a string, or null if an error occurs.
  Future<String?> sendChatMessage(String message) async {
    try {
      final response =
          await _chat.sendMessage(Content.text(message)); // Sends the message
      return _generateSummary(
          response.text!); // Generates a summary of the AI's response
    } catch (e) {
      throw Exception(e.toString()); // Throws an exception if an error occurs
    }
  }

  /// Generates a summary from the AI's response text.
  ///
  /// [responseText] is the text response from the AI model that needs to be summarized.
  ///
  /// Returns the generated summary as a string.
  Future<String?> _generateSummary(String responseText) async {
    // Here you can define how to generate the summary
    // For example, you can use another chat model or some summarization logic
    final summaryResponse = await _chat.sendMessage(
      Content.text(
          'Summarize the following: $responseText'), // Sends a summarization request
    );
    return summaryResponse.text; // Returns the generated summary
  }
}
