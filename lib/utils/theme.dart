import 'package:flutter/material.dart';

import 'color.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade50,
    fontFamily: 'Poppins',
    primaryColor: primaryColor,

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 40,
      ),
      displayMedium: TextStyle(),
      displaySmall: TextStyle(),

      bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.black
      ),
      bodySmall: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: Colors.white
      ),

      headlineLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black
      ),
      headlineMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black
      ),
      headlineSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black
      ),

      titleLarge: TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
      titleMedium: TextStyle(
        fontSize: 10,
        color: Colors.grey,
      ),
      titleSmall: TextStyle(
        fontSize: 8,
        color: Colors.grey,
      ),

      labelLarge: TextStyle(
        fontSize: 14,
        color: Colors.black
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.black
      )
    ),

    iconTheme: IconThemeData(
      color: primaryColor,
    ),

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(15.0),
      hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.6,
          fontSize: 11.0
      ),
      prefixIconColor: primaryColor,
      enabledBorder:  const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0XFF999999)),
        borderRadius: BorderRadius.all( Radius.circular(7.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.0),
        borderSide: const BorderSide(color: Color(0XFF999999)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.0),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.0),
          borderSide: const BorderSide(color: Color(0XFF999999)),
      ),
    ),
    
    cardTheme: CardTheme(
      elevation: 0.4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      )
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      iconSize: 14,
      elevation: 0.5
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor
      )
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 11,
            decoration: TextDecoration.underline,
            color: Colors.white
          )
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontSize: 16,
        letterSpacing: 1.2,
        color: Colors.white,
      )
    ),

    snackBarTheme: SnackBarThemeData(
      contentTextStyle: const TextStyle(
          fontSize: 12,
          color: Colors.white
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: primaryColor,
    )
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black
  );
}