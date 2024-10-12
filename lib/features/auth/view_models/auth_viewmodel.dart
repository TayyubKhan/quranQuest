import 'package:firebase_auth/firebase_auth.dart'; // Importing Firebase Authentication package for user authentication.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importing Riverpod package for state management.
import 'package:quranquest/features/auth/repositories/auth_repository.dart'; // Importing the AuthRepository which handles authentication logic.

// Provider for AuthRepository, allowing its instance to be accessed throughout the app.
final authRepositoryProvider = Provider((ref) => AuthRepository());

// StateNotifierProvider for the AuthViewModel, which manages the state of the authentication process.
// The provider holds the current user state as User? (nullable User).
final authViewModelProvider = StateNotifierProvider<AuthViewModel, User?>((ref) {
  return AuthViewModel(ref.watch(authRepositoryProvider)); // Creating an instance of AuthViewModel with AuthRepository.
});

// AuthViewModel class extends StateNotifier, which is responsible for managing the authentication state.
class AuthViewModel extends StateNotifier<User?> {
  final AuthRepository authRepository; // Instance of AuthRepository for authentication operations.

  // Constructor initializing authRepository and listening for authentication state changes.
  AuthViewModel(this.authRepository) : super(null) {
    // Listening to changes in authentication state and updating the state accordingly.
    authRepository.firebaseAuth.authStateChanges().listen((user) {
      state = user; // Update the state with the current user (null if not authenticated).
    });
  }

  // Method to create a new user account with email and password.
  Future<void> createUser({
    required String email, // Required parameter for user email.
    required String password, // Required parameter for user password.
  }) async {
    // Call the createUser method from authRepository and update the state with the returned user.
    state = await authRepository.createUser(email: email, password: password);
  }

  // Method to sign in an existing user with email and password.
  Future<void> signIn({
    required String email, // Required parameter for user email.
    required String password, // Required parameter for user password.
  }) async {
    // Call the signIn method from authRepository and update the state with the returned user.
    state = await authRepository.signIn(email: email, password: password);
  }

  // Method to sign out the currently authenticated user.
  Future<void> signOut() async {
    await authRepository.signOut(); // Call the signOut method from authRepository to log out.
    state = null; // Set the state to null to indicate that no user is logged in.
  }
}
