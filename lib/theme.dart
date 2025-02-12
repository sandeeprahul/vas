import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
      textTheme: GoogleFonts.montserratTextTheme(), // Apply Montserrat globally
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    textTheme: GoogleFonts.montserratTextTheme(), // Apply Montserrat globally

  );
}
