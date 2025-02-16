import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
      textTheme: GoogleFonts.montserratTextTheme(), // Apply Montserrat globally
    appBarTheme:  AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.blue,  // ✅ Set AppBar background color
      titleTextStyle: GoogleFonts.montserrat(
        color: Colors.white,  // ✅ Set AppBar title color
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,  // ✅ Set AppBar icon color
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle:  GoogleFonts.montserrat(fontSize: 16), // Default text style
        padding: const EdgeInsets.symmetric(vertical: 14), // Default padding
        foregroundColor: Colors.white, // Text color
        backgroundColor: Colors.blue, // Let the button's default background color apply or set it here if needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0), // Rounded corners
        ),
      ),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    textTheme: GoogleFonts.montserratTextTheme(), // Apply Montserrat globally
      appBarTheme:  AppBarTheme(
        backgroundColor: Colors.blue,  // ✅ Set AppBar background color
        titleTextStyle: GoogleFonts.montserrat(
          color: Colors.white,  // ✅ Set AppBar title color
          fontSize: 20,

          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,  // ✅ Set AppBar icon color
        ),
      ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle:  GoogleFonts.montserrat(fontSize: 16), // Default text style
        padding: const EdgeInsets.symmetric(vertical: 14), // Default padding
        foregroundColor: Colors.white, // Text color
        backgroundColor: Colors.blue, // Let the button's default background color apply or set it here if needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0), // Rounded corners
        ),
      ),
    ),
  );
}
