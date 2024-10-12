class AuthDetails {
  final int status;
  final String message;
  final User user; // Represents the authenticated user details
  final String token; // Authentication token, typically used for API authorization

  // Constructor for initializing required fields
  AuthDetails({
    required this.status,
    required this.message,
    required this.user,
    required this.token,
  });

  // Method for copying the instance with updated fields (if provided)
  AuthDetails copyWith({
    int? status,
    String? message,
    User? user,
    String? token,
  }) =>
      AuthDetails(
        status: status ?? this.status, // Use provided value or fall back to current
        message: message ?? this.message,
        user: user ?? this.user,
        token: token ?? this.token,
      );

  // Factory constructor to create an AuthDetails object from a Map (useful for JSON deserialization)
  factory AuthDetails.fromMap(Map<String, dynamic> json) => AuthDetails(
    status: json["status"], // Status code (e.g., 200 for success)
    message: json["message"], // Message returned by the API (e.g., 'Success' or 'Error')
    user: User.fromMap(json["user"]), // Create a User object from the user field in the Map
    token: json["token"], // Token for authentication (e.g., JWT)
  );

  // Method to convert the AuthDetails object to a Map (useful for JSON serialization)
  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "user": user.toMap(), // Convert User object to a Map
    "token": token,
  };
}

// User class representing the user details
class User {
  final String id; // Unique user identifier
  final String email; // User email address
  final String name; // User's full name

  // Constructor to initialize user properties
  User({
    required this.id,
    required this.email,
    required this.name,
  });

  // Method to copy a User object with optional updated fields
  User copyWith({
    String? id,
    String? email,
    String? name,
  }) =>
      User(
        id: id ?? this.id, // Use the provided id, or fall back to current
        email: email ?? this.email,
        name: name ?? this.name,
      );

  // Factory constructor to create a User object from a Map (useful for JSON deserialization)
  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["_id"], // '_id' is a common key for user ID in databases like MongoDB
    email: json["email"], // Extract user email from the Map
    name: json["name"], // Extract user name from the Map
  );

  // Method to convert the User object to a Map (useful for JSON serialization)
  Map<String, dynamic> toMap() => {
    "_id": id,
    "email": email,
    "name": name,
  };
}
