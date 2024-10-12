import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/services.dart';

import '../models/promptModel.dart';

class ChatRepository {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  ChatRepository() {
    _model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: 'AIzaSyApXkoBUzUlDmaLiQ-ltTe49NJqm5N1yxA',
        systemInstruction: Content.text(islamicScholarPrompt));
    _chat = _model.startChat();
  }

  Future<String?> sendChatMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));
      return response.text;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

class SummaryChatRepository {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  SummaryChatRepository() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: 'AIzaSyApXkoBUzUlDmaLiQ-ltTe49NJqm5N1yxA',
      systemInstruction:
          Content.text(summaryPrompt), // Use a summary-specific prompt here
    );
    _chat = _model.startChat();
  }

  Future<String?> sendChatMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));
      return _generateSummary(response.text!);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String?> _generateSummary(String responseText) async {
    // Here you can define how to generate the summary
    // For example, you can use another chat model or some summarization logic
    final summaryResponse = await _chat
        .sendMessage(Content.text('Summarize the following: $responseText'));
    return summaryResponse.text; // Return the generated summary
  }
}
