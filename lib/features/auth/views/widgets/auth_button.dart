import 'package:flutter/material.dart'; // Import the Flutter material package for UI components
import 'package:quranquest/core/extensions/media_query_extensions.dart'; // Import media query extensions for responsive design
import 'package:quranquest/core/themes/color_scheme.dart'; // Import the app's color scheme for consistent theming

// CustomSubmitButton widget for reusable submit button functionality
class CustomSubmitButton extends StatelessWidget {
  final String label; // Label displayed on the button
  final VoidCallback onPressed; // Callback function when the button is pressed
  final VoidCallback? onLongPressed; // Optional callback for long press actions

  // Constructor to initialize the button with required and optional parameters
  const CustomSubmitButton({
    super.key, // Key for the widget, used for widget identification
    required this.label, // Required label for the button
    required this.onPressed, // Required onPressed callback
    this.onLongPressed, // Optional onLongPressed callback
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55, // Fixed height for the button
      width: double.infinity, // Full width to take the available space
      child: FilledButton(
        onPressed: onPressed, // Trigger the onPressed callback
        onLongPress: onLongPressed, // Trigger the onLongPressed callback if provided
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15), // Vertical padding for button content
          backgroundColor: darkColor, // Background color from the app's theme
          foregroundColor: Colors.white, // Text color for the button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners for the button
          ),
          textStyle: context.tTheme.bodySmall!.copyWith( // Text style based on the current theme
            color: lightColor, // Light color for the button text
          ),
        ),
        child: Text(
          label, // Display the button label
          style: context.tTheme.bodyMedium!.copyWith( // Apply medium text style for the label
            color: lightColor, // Light color for the label text
            fontWeight: FontWeight.bold, // Make the label text bold
          ),
        ),
      ),
    );
  }
}
