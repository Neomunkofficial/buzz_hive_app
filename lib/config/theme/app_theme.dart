import 'package:flutter/material.dart';
import '../Colors/AppColors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primaryYellow,
    fontFamily: "Font1", // Mansalva
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: "Font1",
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.lightText,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Font2",
        fontSize: 16,
        color: AppColors.lightText,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.primaryYellow,
    fontFamily: "Font1",
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: "Font1",
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.darkText,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Font2",
        fontSize: 16,
        color: AppColors.darkText,
      ),
    ),
  );
}
