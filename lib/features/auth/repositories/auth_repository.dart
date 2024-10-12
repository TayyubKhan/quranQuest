import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Method to create a new user with email and password
  Future<User?> createUser({
    required String email,
    required String password,
  }) async {
    try {
      // Calls Firebase's createUserWithEmailAndPassword method
      UserCredential userCredential =
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Returns the user if creation is successful
    } catch (e) {
      // Throws an exception if user creation fails
      throw Exception('Failed to create user: $e');
    }
  }

  // Method to sign in an existing user
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Calls Firebase's signInWithEmailAndPassword method
      UserCredential userCredential =
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Returns the user if sign-in is successful
    } catch (e) {
      // Throws an exception if sign-in fails
      throw Exception('Failed to sign in: $e');
    }
  }

  // Method to sign out the current user
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut(); // Signs out the user
    } catch (e) {
      // Throws an exception if sign-out fails
      throw Exception('Failed to sign out: $e');
    }
  }
}
