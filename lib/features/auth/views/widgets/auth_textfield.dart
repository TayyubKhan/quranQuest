import 'package:flutter/material.dart'; // Import Flutter's material package for UI components
import 'package:quranquest/core/extensions/media_query_extensions.dart'; // Import extensions for responsive design
import 'package:quranquest/core/themes/color_scheme.dart'; // Import the app's color scheme for consistent theming
import 'package:quranquest/features/auth/views/widgets/input_decoration.dart'; // Import input decoration utility

// QuranQuestTextField widget for creating a customizable text field
class QuranQuestTextField extends StatelessWidget {
  final TextEditingController controller; // Controller to manage the text input
  final String label; // Label displayed above the text field
  final bool obscureText; // Flag for password obscuring
  final bool enabled; // Flag to enable or disable the text field
  final FormFieldValidator<String>? validator; // Validator function for input validation
  final InputBorder? errorBorder; // Border style for the text field when there's an error
  final InputBorder? focusedErrorBorder; // Border style when focused and there's an error
  final InputBorder? enabledBorder; // Border style when the text field is enabled
  final InputBorder? focusedBorder; // Border style when the text field is focused

  // Constructor for the QuranQuestTextField widget
  const QuranQuestTextField({
    super.key, // Key for the widget, used for widget identification
    required this.controller, // Required controller for managing input text
    required this.label, // Required label for the text field
    this.obscureText = false, // Default to false for not obscuring text
    this.enabled = true, // Default to true for enabling the text field
    this.validator, // Optional validator for input validation
    this.errorBorder, // Optional error border style
    this.focusedErrorBorder, // Optional focused error border style
    this.enabledBorder, // Optional enabled border style
    this.focusedBorder, // Optional focused border style
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Assign the text editing controller
      obscureText: obscureText, // Set if the text should be obscured
      enabled: enabled, // Enable or disable the text field
      style: context.tTheme.bodyMedium!.copyWith( // Text style based on current theme
        color: darkColor, // Set text color to darkColor from the app theme
      ),
      cursorColor: darkColor, // Set cursor color to darkColor
      decoration: inputDecoration( // Call the inputDecoration function for consistent styling
        context: context,
        labelText: label, // Set the label text
        hintText: label, // Set the hint text to the same as the label
      ),
      validator: validator, // Set the validator for input validation
    );
  }
}
