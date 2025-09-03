// presentation/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import '../../../config/Colors/AppColors.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: size.width * 0.2,
              color: AppColors.primaryPink,
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              "Your Profile",
              style: theme.textTheme.headlineLarge?.copyWith(
                fontSize: size.width * 0.08,
                fontWeight: FontWeight.bold,
                fontFamily: "Font1",
                color: AppColors.primaryPink,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              "Profile management\ncoming soon! ✨",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: size.width * 0.04,
                fontFamily: "Font3",
              ),
            ),
          ],
        ),
      ),
    );
  }
}