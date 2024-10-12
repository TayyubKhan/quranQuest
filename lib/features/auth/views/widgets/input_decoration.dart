import 'package:flutter/material.dart'; // Import Flutter's material package for UI components
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts for text styling
import 'package:quranquest/core/extensions/media_query_extensions.dart'; // Import extensions for responsive design

import '../../../../core/themes/color_scheme.dart'; // Import the app's color scheme for consistent theming

// Function to create a customizable InputDecoration for text fields
InputDecoration inputDecoration({
  required BuildContext context, // Required context for theme and localization
  required String labelText, // Required label text displayed above the text field
  String? hintText, // Optional hint text displayed when the text field is empty
  Widget? suffixIcon, // Optional suffix icon to display at the end of the text field
}) {
  return InputDecoration(
    labelText: labelText, // Set the label text
    hintText: hintText ?? '', // Set the hint text, defaulting to an empty string if not provided
    filled: true, // Enable the fill color for the text field
    labelStyle: GoogleFonts.nunito(color: darkColor), // Set the label style using Google Fonts
    fillColor: darkColor.withOpacity(0.2), // Set the fill color with some opacity for a lighter appearance
    border: InputBorder.none, // Remove the default border
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Set padding inside the text field

    // Style for the enabled border
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15), // Rounded corners
      borderSide: BorderSide.none, // No border on enabled state
    ),

    // Style for the focused border
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15), // Rounded corners
      borderSide: BorderSide.none, // No border on focused state
    ),

    // Style for the error border when validation fails
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15), // Rounded corners
      borderSide: const BorderSide(color: Colors.red, width: 0.5), // Red border to indicate an error
    ),

    // Style for the focused error border
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15), // Rounded corners
      borderSide: const BorderSide(color: Colors.red, width: 1.0), // Thicker red border when focused
    ),
    suffixIcon: suffixIcon, // Assign the optional suffix icon
  );
}
