import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final light = ThemeData(
    primaryColor: const Color(0xFF3B3486),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF3B3486),
      secondary: Colors.orange,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      hintStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      floatingLabelStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
     /* enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFF3B3486), width: 2),
      ),*/
      border: InputBorder.none,

     /* errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),*/
      /*focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),*/
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme:  AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.blue,  // ✅ Set AppBar background color
      titleTextStyle: GoogleFonts.poppins(
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
        textStyle:  GoogleFonts.poppins(fontSize: 16), // Default text style
        padding: const EdgeInsets.symmetric(vertical: 14), // Default padding
        foregroundColor: Colors.white, // Text color
        backgroundColor: Colors.blue, // Let the button's default background color apply or set it here if needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0), // Rounded corners
        ),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF3B3486); // Selected color
        }
        return Colors.grey; // Unselected color
      }),
      overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.hovered)) {
          return const Color(0xFF3B3486).withOpacity(0.1); // Hover color
        }
        return Colors.transparent;
      }),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme:  AppBarTheme(
        backgroundColor: Colors.blue,  // ✅ Set AppBar background color
        titleTextStyle: GoogleFonts.poppins(
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
        textStyle:  GoogleFonts.poppins(fontSize: 16), // Default text style
        padding: const EdgeInsets.symmetric(vertical: 14), // Default padding
        foregroundColor: Colors.white, // Text color
        backgroundColor: Colors.blue, // Let the button's default background color apply or set it here if needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0), // Rounded corners
        ),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.blue; // Selected color
        }
        return Colors.grey.shade400; // Unselected color
      }),
      overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.hovered)) {
          return Colors.blue.withOpacity(0.1); // Hover color
        }
        return Colors.transparent;
      }),
    ),
  );
}
