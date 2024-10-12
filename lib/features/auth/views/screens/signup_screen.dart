import 'package:flutter/material.dart'; // Import the Material package for UI components
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod for state management
import 'package:go_router/go_router.dart'; // Import GoRouter for navigation
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts for custom text styles
import 'package:quranquest/core/utils/validators.dart'; // Import validators for input validation
import 'package:quranquest/features/auth/view_models/auth_viewmodel.dart'; // Import Auth ViewModel for authentication logic
import 'package:quranquest/features/auth/views/widgets/auth_button.dart'; // Import custom button widget for authentication
import 'package:quranquest/features/auth/views/widgets/auth_textfield.dart'; // Import custom text field widget
import 'package:quranquest/features/auth/views/widgets/input_decoration.dart'; // Import custom input decoration for text fields
import 'package:quranquest/core/extensions/media_query_extensions.dart'; // Import extensions for media query utility functions

import '../../../../core/go_router/router.dart'; // Import the app's router for navigation
import '../../../../core/themes/color_scheme.dart'; // Import the color scheme for theming

// SignUpScreen widget that provides the user interface for signing up.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key}); // Constructor with an optional key parameter

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState(); // Create the corresponding state for the SignUpScreen
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>(); // Global key for managing form state
  // Text editing controllers for the input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // Boolean flag to indicate loading state

  // Method to handle user sign-up action
  void _signUp() async {
    // Validate the form inputs
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Set loading state to true to indicate processing
      });

      final authViewModel = ref.read(authViewModelProvider.notifier); // Access the Auth ViewModel for user management

      try {
        // Attempt to create a new user with the provided email and password
        await authViewModel.createUser(
          email: _emailController.text, // Retrieve email from the text controller
          password: _passwordController.text, // Retrieve password from the text controller
        );
        // Navigate to the chat screen after successful sign-up
        AppRouter.router.pushNamed(RouteTo.chat);
      } catch (e) {
        // If an error occurs, display a snackbar with an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sign up')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Reset loading state
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), // Horizontal padding for the entire screen
          child: SingleChildScrollView( // Allows scrolling for the content
            child: Form(
              key: _formKey, // Attach the form key to manage form validation
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
                children: [
                  // Sign-up header
                  Text(
                    'Sign Up',
                    style: GoogleFonts.nunito( // Use Google Fonts for custom text styling
                      color: darkColor, // Set text color to darkColor defined in the theme
                      fontWeight: FontWeight.bold, // Make the font bold
                      fontSize: 50, // Set font size
                    ),
                  ),
                  const SizedBox(height: 5), // Space between header and subtitle
                  Text(
                    'Join the Journey',
                    style: GoogleFonts.nunito( // Subtitle styling
                      color: darkColor, // Set text color to darkColor
                      fontWeight: FontWeight.bold, // Make the font bold
                      fontSize: 15, // Set font size
                    ),
                  ),
                  const SizedBox(height: 20), // Space before the input fields
                  // ConstrainedBox limits the width of input fields
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400), // Maximum width of 400 pixels
                    child: Column(
                      children: [
                        // Input field for user's name
                        QuranQuestTextField(
                          controller: _nameController, // Bind to name controller
                          label: 'Name', // Label for the input field
                          validator: Validators.validateName, // Validation function for name
                        ),
                        const SizedBox(height: 10), // Space between input fields
                        // Input field for user's email
                        QuranQuestTextField(
                          controller: _emailController, // Bind to email controller
                          label: 'Email', // Label for the input field
                          validator: Validators.validateEmail, // Validation function for email
                        ),
                        const SizedBox(height: 10), // Space between input fields
                        // Input field for user's password
                        QuranQuestTextField(
                          controller: _passwordController, // Bind to password controller
                          label: 'Password', // Label for the input field
                          obscureText: true, // Mask the input text for password
                          validator: Validators.validatePassword, // Validation function for password
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40), // Space before the submit button
                  // Show loading indicator or the submit button based on loading state
                  _isLoading
                      ? CircularProgressIndicator( // Loading indicator when signing up
                    color: darkColor, // Set color of the loading indicator
                  )
                      : ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400), // Maximum width for button
                    child: CustomSubmitButton(
                      // Pre-fill input fields for testing purposes on long press
                      onLongPressed: () {
                        _nameController.text = 'Tayyub'; // Example name
                        _emailController.text = 'tayyubshafiquek@gmail.com'; // Example email
                        _passwordController.text = '@Tayyub123'; // Example password
                      },
                      label: 'Sign Up', // Label for the button
                      onPressed: _signUp, // Call sign-up method when pressed
                    ),
                  ),
                  const SizedBox(height: 20), // Space before the sign-in link
                  // Link to navigate to the sign-in screen
                  Center(
                    child: TextButton(
                      onPressed: () {
                        AppRouter.router.go(RouteTo.signIn); // Navigate to sign-in route
                      },
                      child: Text(
                        "Already have an account? Sign in", // Link text
                        style: context.tTheme.bodySmall!.copyWith(
                          color: darkColor, // Set color for the link text
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
