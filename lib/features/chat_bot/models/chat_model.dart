import 'package:cloud_firestore/cloud_firestore.dart';

/// A class representing a chat message.
class ChatMessage {
  /// The content of the message.
  final String text;

  /// A boolean indicating if the message is sent by the user (true) or received (false).
  final bool fromUser;

  /// The timestamp of when the message was sent or received.
  final DateTime timestamp;

  /// Creates an instance of [ChatMessage].
  ///
  /// [text] is the content of the message.
  /// [fromUser] indicates whether the message is from the user.
  /// [timestamp] is the time the message was sent or received.
  ChatMessage({
    required this.text,
    required this.fromUser,
    required this.timestamp,
  });

  /// Converts the [ChatMessage] instance to a map representation.
  ///
  /// This map can be used for serialization, for example, when saving to a database.
  ///
  /// Returns a map containing the message's properties.
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'fromUser': fromUser,
      'timestamp': timestamp,
    };
  }

  /// Creates a [ChatMessage] instance from a map.
  ///
  /// [map] must contain the keys 'text', 'fromUser', and 'timestamp'.
  /// The 'timestamp' is expected to be a Firestore Timestamp, which will be converted to a DateTime.
  ///
  /// Returns an instance of [ChatMessage].
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'],
      fromUser: map['fromUser'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
