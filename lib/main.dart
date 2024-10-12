import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/go_router/router.dart'; // Importing custom routing configuration from your project
import 'firebase_options.dart'; // Importing Firebase configuration options for the current platform

// The main entry point of the application
Future<void> main() async {
  // Ensures that all widgets are bound to the Flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing Firebase before the app starts
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Loads Firebase options for the current platform (Android, iOS, etc.)
  );

  // Running the app and wrapping it with ProviderScope to enable Riverpod state management throughout the app
  runApp(const ProviderScope(child: App()));
}

// The root widget of the application
// Extends ConsumerWidget to allow listening to Riverpod providers
class App extends ConsumerWidget {
  const App({super.key}); // Constructor for the App widget

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The MaterialApp.router widget is used to configure routing in the app
    return MaterialApp.router(
      debugShowCheckedModeBanner: false, // Disables the debug banner
      // Provides the route information used to build the navigation stack
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      // Parses the route information into data that can be used by the router delegate
      routeInformationParser: AppRouter.router.routeInformationParser,
      // The router delegate that manages the navigation stack
      routerDelegate: AppRouter.router.routerDelegate,
      title: 'GoRouter', // Title of the application
    );
  }
}
