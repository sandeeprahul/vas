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
    )
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
      )
  );
}
