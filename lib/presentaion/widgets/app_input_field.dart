import 'package:flutter/material.dart';
import '../../config/Colors/AppColors.dart';

class AppInputField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;

  // Customization
  final double? width;
  final double? height;
  final double borderRadius;
  final double fontSize;
  final String? fontFamily;
  final int maxLines;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool readOnly;
  final bool enabled;

  const AppInputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.fontSize = 14,
    this.fontFamily,
    this.maxLines = 1,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword; // start obscured only if it's a password field
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Adaptive fill color
    final fillColor = theme.brightness == Brightness.light
        ? Colors.white
        : Colors.grey.shade900; // slightly lighter than background

    // Adaptive border color
    final borderColor = theme.brightness == Brightness.light
        ? AppColors.lightText.withOpacity(0.3)
        : Colors.grey.shade600;

    final focusedBorderColor = theme.brightness == Brightness.light
        ? AppColors.primaryYellow
        : AppColors.primaryYellow.withOpacity(0.8);

    Widget textField = TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscure : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: widget.fontSize,
        fontFamily: widget.fontFamily ?? "Font2",
        color: theme.brightness == Brightness.light
            ? Colors.black
            : Colors.white,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontFamily: widget.fontFamily ?? "Font2",
          fontSize: widget.fontSize,
          color: Colors.grey,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: focusedBorderColor, width: 2),
        ),
        filled: true,
        fillColor: fillColor,
      ),
    );

    if (widget.width != null || widget.height != null) {
      textField = SizedBox(
        width: widget.width,
        height: widget.height,
        child: textField,
      );
    }

    return textField;
  }
}
