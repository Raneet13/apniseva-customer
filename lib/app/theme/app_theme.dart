import 'package:flutter/material.dart';
import 'app_text_styles.dart';

ThemeData get lightTheme {
  return ThemeData(
    fontFamily: 'Poppins',
    textTheme: const TextTheme(
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      titleMedium: AppTextStyles.titleMedium,
      headlineLarge: AppTextStyles.headingLarge,
    ),
  );
}
