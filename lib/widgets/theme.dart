import 'package:flutter/material.dart';
//import 'package:velocity_x/velocity_x.dart';  // Assuming you're not using Vx, else you can uncomment it

class Mytheme {
  // Light theme configuration with blue shades
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      scaffoldBackgroundColor: Mytheme.lightBackground,
      primaryColor: Mytheme.lightPrimaryBlue, // Primary color set to a light blue
      primarySwatch: Colors.blue,
      cardColor: Colors.white,
      canvasColor: creamColor,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.light,
        accentColor: darkBlueAccent, // Accent color set to a darker blue
        backgroundColor: Colors.white,
      ),
      // Using default font family instead of Google Fonts
      appBarTheme: AppBarTheme(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Mytheme.lightPrimaryBlue,
        foregroundColor: Mytheme.lightForeground,
        elevation: 0.0,
      ));

  // Dark theme configuration with blue shades
  static ThemeData darkTheme(BuildContext context) => ThemeData(
      scaffoldBackgroundColor: Mytheme.darkBackground,
      primaryColor: Mytheme.darkPrimaryBlue, // Darker blue for primary color
      dividerColor: darkForeground,
      cardColor: Colors.black,
      hintColor: darkForeground,
      iconTheme: const IconThemeData(color: darkForeground),
      canvasColor: darkCreamColor,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        accentColor: darkBlueAccent, // Accent color remains dark blue
      ),
      appBarTheme: AppBarTheme(
        iconTheme: const IconThemeData(color: darkForeground),
        color: Mytheme.darkPrimaryBlue,
        elevation: 0.0,
      ));

  // Blue color palette
  static Color lightPrimaryBlue = const Color(0xFF42A5F5); // Lighter blue
  static Color darkPrimaryBlue = const Color(0xFF0D47A1); // Dark blue
  static Color darkBlueAccent = const Color(0xFF1976D2); // Dark blue accent

  // Other colors (you can retain these as needed or change them accordingly)
  static Color creamColor = const Color(0xfff5f5f5);
  static Color darkCreamColor = const Color(0xFF303030); // Replaced Vx.gray900 with a similar value
  static Color bluishColor = const Color(0xFF3F51B5); // Replaced Vx.indigo500 with a similar value

  // Light mode colors
  static const Color lightBackground = Colors.white;
  static const Color lightForeground = Colors.black;

  // Dark mode colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkForeground = Colors.white;
  static const Color darkCardBackground = Color(0xFF1E1E1E);
}
