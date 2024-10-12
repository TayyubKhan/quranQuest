import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  // Register with email and password
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  // Check if the user is signed in
  User? getCurrentUser() {
    return _auth.currentUser; // This will return the current user or null if not signed in
  }

  // Method to initialize Firebase Authentication for web
  void initializeAuth() {
    // Ensure auth state persistence for web
    _auth.setPersistence(Persistence.LOCAL).then((_) {
      print("Firebase auth persistence set to LOCAL for web.");
    }).catchError((error) {
      print("Error setting auth persistence: $error");
    });
  }
}

// This provider listens to the current auth state
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
