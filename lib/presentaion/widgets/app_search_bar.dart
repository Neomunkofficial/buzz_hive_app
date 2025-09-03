import 'package:flutter/material.dart';
import '../../../../config/Colors/AppColors.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final double height;
  final double width;
  final double fontSize;

  const AppSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = "Search interests...",
    this.height = 50, // default height
    this.width = double.infinity, // takes full width by default
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          color: isDark ? AppColors.darkText: AppColors.lightText,
          fontSize: fontSize,
          fontFamily: "Font3",
        ),
        cursorColor: isDark ? AppColors.darkText: AppColors.lightText,
        decoration: InputDecoration(
          filled: true,
          fillColor: isDark ? Colors.grey[850] : Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),

          hintText: hintText,
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[500] : Colors.grey[600],
            fontFamily: "Font3",
            fontSize: fontSize,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.search,
              size: 22,
              color: isDark ? AppColors.darkText: AppColors.lightText,
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minHeight: 40,
            minWidth: 40,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // capsule style
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: isDark ? AppColors.primaryYellow : AppColors.primaryYellow,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
