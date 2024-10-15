import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quranquest/core/go_router/router.dart';
import '../../../../core/themes/color_scheme.dart';
import 'chat_screen.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: darkColor, // Set the background color
      appBar: AppBar(
        title: Text(
          'QuranQuest',
          style: GoogleFonts.nunito(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Use white text on dark background)
          ),
        ),
        centerTitle: true,
        backgroundColor: darkColor, // Set AppBar color to darkColor
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome to QuranQuest',
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Use white text on dark background)
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ask any question',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70, // A lighter shade of white
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: darkColor,
                  backgroundColor: Colors.white, // Button text color
                ),
                onPressed: () {
                  updateGeneralProvider(ref, false);
                  updateTopicProvider(ref, '');
                  AppRouter.router.go(RouteTo.chat);
                },
                child: const Text('Precise'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: darkColor,
                  backgroundColor: Colors.white, // Button text color
                ),
                onPressed: () {
                  updateGeneralProvider(ref, true);
                  AppRouter.router.go(RouteTo.chat);
                },
                child: const Text('General'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
