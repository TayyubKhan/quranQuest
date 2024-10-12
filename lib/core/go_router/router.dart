import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication package
import 'package:flutter/cupertino.dart'; // For creating iOS-styled widgets
import 'package:go_router/go_router.dart'; // Routing package for navigation
import 'package:quranquest/features/auth/views/screens/login_screen.dart'; // Login screen import
import 'package:quranquest/features/auth/views/screens/signup_screen.dart'; // Signup screen import
import 'package:quranquest/features/chat_bot/views/screens/chat_screen.dart'; // Chat screen import

import '../../features/auth/services/auth_service.dart'; // Importing custom auth services

part 'routes_const.dart'; // Part directive for route constants

// Class that manages the application's routing configuration
class AppRouter {
  // A global key for the root navigator of the app
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  // GoRouter instance that defines routes and handles navigation
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true, // Enables detailed diagnostic logs for debugging
    navigatorKey:
        _rootNavigatorKey, // Assigning the global navigator key to the GoRouter instance
    initialLocation:
        RouteTo.signIn, // Initial location when the app is first loaded

    // Redirect logic for handling route changes based on authentication status
    redirect: (context, state) async {
      // Get the currently signed-in user from FirebaseAuth
      final user = FirebaseAuth.instance.currentUser;

      // Get the current route the user is trying to navigate to
      final currentRoute = state.uri.toString();
      final isInitialRoute =
          currentRoute == '/'; // Check if this is the app's initial route

      // Define boolean variables for specific routes
      final goingToLogin = currentRoute == RouteTo.signIn; // Login route check
      final goingToSignup =
          currentRoute == RouteTo.signUp; // Signup route check
      final goingToChat = currentRoute == RouteTo.chat; // Chat route check

      // Print debugging information about the current state and user authentication status
      debugPrint('Current user: ${user?.email}');
      debugPrint(
          'Initial route: $isInitialRoute, Navigating to login: $goingToLogin, signup: $goingToSignup, chat: $goingToChat');

      // Logic for when the app is first opened
      if (isInitialRoute) {
        // If the user is signed in, redirect to the chat screen
        if (user != null) {
          return RouteTo.chat;
        } else {
          // If the user is not signed in, redirect to the login screen
          return RouteTo.signIn;
        }
      }

      // If the user is trying to go to the chat but is not signed in
      if (user == null && goingToChat) {
        return RouteTo.signIn; // Redirect to login if not authenticated
      }

      // Prevent users who are already signed in from accessing login or signup screens
      if (user != null && (goingToLogin || goingToSignup)) {
        return RouteTo.chat; // Redirect to chat if the user is authenticated
      }

      // Prevent unnecessary redirection if the user is already on the login screen
      if (goingToLogin && currentRoute == RouteTo.signIn && user == null) {
        return null; // No redirection needed, stay on login
      }

      // Prevent unnecessary redirection if the user is already on the signup screen
      if (goingToSignup && currentRoute == RouteTo.signUp && user == null) {
        return null; // No redirection needed, stay on signup
      }

      // If no redirection is required, return null to continue with the current navigation
      return null;
    },

    // Defining the routes for the application
    routes: [
      GoRoute(
        name: RouteTo.signIn, // Name of the route for logging in
        path: '/signIn', // Path for the login screen
        builder: (context, state) =>
            const SignInScreen(), // Widget to build when navigating to this route
      ),
      GoRoute(
        name: RouteTo.chat, // Name of the route for the chat screen
        path: '/chat', // Path for the chat screen
        builder: (context, state) =>
            const ChatScreen(), // Widget to build when navigating to the chat screen
      ),
      GoRoute(
        name: RouteTo.signUp, // Name of the route for signing up
        path: '/signUp', // Path for the signup screen
        builder: (context, state) =>
            const SignUpScreen(), // Widget to build when navigating to the signup screen
      ),
    ],

    // This function will be called when the app cannot find a route
    errorBuilder: (context, state) => const Text(
        'Route Not Found'), // Simple error message for undefined routes
  );
}
