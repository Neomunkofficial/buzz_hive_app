import 'package:flutter/material.dart';
import '../../../../config/Colors/AppColors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // ✅ Changed to nullable VoidCallback?
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final double? height;
  final Widget? icon; // can be Icon or Image
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed, // This can now be null for disabled state
    this.backgroundColor = AppColors.primaryYellow,
    this.textColor = AppColors.lightText,
    this.width,
    this.height,
    this.icon,
    this.borderRadius = 12,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w700, // bolder by default
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, // default full width
      height: height ?? 56, // default height
      child: ElevatedButton(
        onPressed: onPressed, // ✅ This now properly handles null for disabled state
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 3,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: 'Font3',
                fontWeight: fontWeight,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}