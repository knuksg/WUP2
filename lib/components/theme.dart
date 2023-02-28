import 'package:flutter/material.dart';
import 'package:wup/components/constants.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      color: kPrimaryColor,
    ),
    primaryColor: kPrimaryColor,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: kPrimaryColor,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

TextTheme textTheme() {
  return TextTheme(
    displayLarge:
        GoogleFonts.openSans(fontSize: 18.0, fontWeight: FontWeight.bold),
    displayMedium:
        GoogleFonts.openSans(fontSize: 16.0, fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.openSans(fontSize: 16.0),
    bodyLarge: GoogleFonts.openSans(fontSize: 15.0),
    bodyMedium: GoogleFonts.openSans(fontSize: 14.0),
  );
}
