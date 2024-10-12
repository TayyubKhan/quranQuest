import 'package:flutter/material.dart';

// Extension on BuildContext to provide easy access to common MediaQuery and Theme properties
extension BuildContextExten on BuildContext {
  // Gets the height of the screen based on MediaQuery
  double get height => MediaQuery.of(this).size.height;

  // Gets the width of the screen based on MediaQuery
  double get width => MediaQuery.of(this).size.width;

  // Returns true if the screen width is less than 600 pixels, identifying a mobile device
  bool get isMobile => MediaQuery.of(this).size.width < 600;

  // Returns true if the screen width is between 600 and 900 pixels, identifying a tablet device
  bool get isTablet => MediaQuery.of(this).size.width >= 600 && MediaQuery.of(this).size.width < 900;

  // Returns true if the screen width is greater than or equal to 900 pixels, identifying a desktop device
  bool get isDesktop => MediaQuery.of(this).size.width >= 900;

  /// Returns the current text theme of the app (fonts, sizes, etc.), allowing easy access to text styles
  TextTheme get tTheme => Theme.of(this).textTheme;

  /// Returns the current color scheme of the app, giving quick access to colors used across the app
  ColorScheme get cScheme => Theme.of(this).colorScheme;
}
