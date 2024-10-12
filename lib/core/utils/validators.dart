class Validators {
  // Validator for the Name field
  static String? validateName(String? value) {
    // Check if the name is null or empty
    if (value == null || value.isEmpty) {
      // If the input is empty, return an error message
      return 'Please enter your name';
    }
    // If the input is valid, return null (no error)
    return null;
  }

  // Validator for the Email field
  static String? validateEmail(String? value) {
    // Check if the email field is null or empty
    if (value == null || value.isEmpty) {
      return 'Please enter your email'; // Return error if email is empty
    }

    // Regular expression to match a valid email format (simplified pattern)
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    // Check if the entered email matches the regular expression
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address'; // Return error if invalid email
    }

    return null; // No errors if email is valid
  }

  // Validator for the Password field
  static String? validatePassword(String? value) {
    // Check if the password field is null or empty
    if (value == null || value.isEmpty) {
      return 'Please enter your password'; // Return error if password is empty
    }

    // Minimum length validation: Password must be at least 8 characters long
    if (value.length < 8) {
      return 'Password must be at least 8 characters long'; // Return error if password is too short
    }

    // At least one special character validation
    final specialCharRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (!specialCharRegExp.hasMatch(value)) {
      return 'Password must contain at least one special character'; // Return error if no special character
    }

    // At least one lowercase letter validation
    final lowercaseRegExp = RegExp(r'[a-z]');
    if (!lowercaseRegExp.hasMatch(value)) {
      return 'Password must contain at least one lowercase letter'; // Return error if no lowercase letter
    }

    // At least one uppercase letter validation
    final uppercaseRegExp = RegExp(r'[A-Z]');
    if (!uppercaseRegExp.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter'; // Return error if no uppercase letter
    }

    // At least one digit validation
    final digitRegExp = RegExp(r'[0-9]');
    if (!digitRegExp.hasMatch(value)) {
      return 'Password must contain at least one digit'; // Return error if no digit
    }

    return null; // No errors if password meets all the criteria
  }
}
