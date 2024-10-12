import 'package:flutter/material.dart'; // Importing Flutter Material package for UI components.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importing Riverpod package for state management.
import 'package:google_fonts/google_fonts.dart'; // Importing Google Fonts package for custom font styles.
import 'package:quranquest/core/extensions/media_query_extensions.dart'; // Importing custom MediaQuery extensions for responsive design.
import 'package:quranquest/core/go_router/router.dart'; // Importing the router for navigation.
import 'package:quranquest/core/themes/color_scheme.dart'; // Importing custom color scheme for the app.
import 'package:quranquest/core/utils/validators.dart'; // Importing validators for form inputs.
import 'package:quranquest/features/auth/views/widgets/auth_button.dart'; // Importing custom button widget for authentication.
import 'package:quranquest/features/auth/views/widgets/auth_textfield.dart'; // Importing custom text field widget for authentication.
import 'package:quranquest/features/auth/view_models/auth_viewmodel.dart'; // Importing the AuthViewModel for authentication logic.

// SignInScreen class is a ConsumerStatefulWidget for signing in users.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key}); // Constructor with key.

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState(); // Creates the state for this screen.
}

// _SignInScreenState class manages the state for SignInScreen.
class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>(); // Key to uniquely identify the form.
  final _emailController = TextEditingController(); // Controller for email input.
  final _passwordController = TextEditingController(); // Controller for password input.

  bool _isLoading = false; // State variable to track loading status.

  // Method to handle sign-in logic when the user presses the sign-in button.
  void _signIn() async {
    // Validate the form inputs before proceeding.
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Set loading state to true while signing in.
      });
      final authViewModel = ref.read(authViewModelProvider.notifier); // Accessing the AuthViewModel instance.
      try {
        // Attempt to sign in with the provided email and password.
        await authViewModel.signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
        AppRouter.router.go(RouteTo.chat); // Navigate to chat screen on successful sign-in.
      } catch (e) {
        // Show error message if sign-in fails.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: darkColor, // Set background color for the snack bar.
            content: Text(
              'Failed to sign in', // Error message content.
              style: GoogleFonts.nunito(color: Colors.white), // Custom font style for the message.
            ),
          ),
        );
      } finally {
        // Reset loading state after the sign-in attempt.
        setState(() {
          _isLoading = false; // Set loading state to false after sign-in process.
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the app is running on a web platform based on screen width.
    final isWeb = MediaQuery.of(context).size.width > 600;
    final buttonWidth = isWeb ? 400.0 : double.infinity; // Set button width based on platform.

    // Build the Sign In screen UI.
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the content.
          child: Form(
            key: _formKey, // Attach the form key for validation.
            child: SingleChildScrollView( // Allow scrolling for smaller screens.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Center align the children.
                children: [
                  Text(
                    'Sign In', // Title of the screen.
                    style: GoogleFonts.nunito(
                        color: darkColor, // Text color.
                        fontWeight: FontWeight.bold, // Bold text.
                        fontSize: 50), // Font size.
                  ),
                  const SizedBox(height: 5), // Spacer.
                  Text(
                    'Begin Your Quest', // Subtitle for the screen.
                    style: GoogleFonts.nunito(
                        color: darkColor, // Text color.
                        fontWeight: FontWeight.bold, // Bold text.
                        fontSize: 15), // Font size.
                  ),
                  const SizedBox(height: 20), // Spacer.
                  SizedBox(
                    width: isWeb ? 400 : double.infinity, // Set width for text field.
                    child: QuranQuestTextField(
                      controller: _emailController, // Email input controller.
                      label: 'Email', // Label for the email text field.
                      validator: Validators.validateEmail, // Email validation function.
                    ),
                  ),
                  const SizedBox(height: 15), // Spacer.
                  SizedBox(
                    width: isWeb ? 400 : double.infinity, // Set width for password text field.
                    child: QuranQuestTextField(
                      controller: _passwordController, // Password input controller.
                      label: 'Password', // Label for the password text field.
                      obscureText: true, // Hide the password input.
                      validator: Validators.validatePassword, // Password validation function.
                    ),
                  ),
                  const SizedBox(height: 30), // Spacer.
                  _isLoading
                      ? CircularProgressIndicator(
                    color: darkColor, // Show loading indicator if signing in.
                  )
                      : SizedBox(
                    width: buttonWidth, // Apply responsive button width.
                    child: CustomSubmitButton(
                      label: 'Sign In', // Button label.
                      onPressed: _signIn, // Callback for button press.
                      onLongPressed: () {
                        // Autofill credentials on long press for testing.
                        _emailController.text = 'tayyubshafiquek@gmail.com';
                        _passwordController.text = '@Tayyub123';
                      },
                    ),
                  ),
                  const SizedBox(height: 15), // Spacer.
                  Center(
                    child: TextButton(
                      onPressed: () {
                        AppRouter.router.go(RouteTo.signUp); // Navigate to sign-up screen.
                      },
                      child: Text(
                        "Don't have an account? Create", // Text prompting user to create an account.
                        style: context.tTheme.bodySmall!.copyWith(
                          color: darkColor, // Set text color.
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
