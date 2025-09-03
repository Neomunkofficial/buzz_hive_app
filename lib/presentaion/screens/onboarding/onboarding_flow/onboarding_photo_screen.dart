// presentation/screens/onboarding_flow/onboarding_photo_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../config/Colors/AppColors.dart';
import '../../../../state/onboarding_provider.dart';
import '../../../widgets/app_button.dart';
import '../onboarding_flow/widgets/onboarding_progress.dart';
// NEXT screen: update accordingly
import 'onboarding_interests_screen.dart';
import 'onboarding_social_media_linking.dart';

class OnboardingPhotoScreen extends StatefulWidget {
  const OnboardingPhotoScreen({super.key});

  @override
  State<OnboardingPhotoScreen> createState() => _OnboardingPhotoScreenState();
}

class _OnboardingPhotoScreenState extends State<OnboardingPhotoScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _dp;
  final List<File?> _gallery = List.generate(6, (_) => null);

  Future<void> _pickImage(bool isDp, {int? index}) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isDp) {
          _dp = File(picked.path);
        } else if (index != null) {
          _gallery[index] = File(picked.path);
        }
      });
    }
  }

  Future<void> _submitAndNext() async {
    if (_dp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please set your Hive DP")),
      );
      return;
    }

    // Collect selected gallery images
    final selectedGallery = _gallery.whereType<File>().toList();

    // Save in provider for state continuity
    final onboarding = context.read<OnboardingProvider>();
    // onboarding.setProfilePhoto(_dp!);
    // onboarding.setGalleryPhotos(selectedGallery);

    // 🔹 TODO: Integrate with backend here
    // Example (pseudo-code, replace with real API client):
    // await UserRepository(ApiClient()).uploadPhotos(
    //   dp: _dp!,
    //   gallery: selectedGallery,
    // );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OnboardingSocialMediaLinkingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          child: Column(
            children: [
              const OnboardingProgress(step: 7),

              const SizedBox(height: 10),

              // Heading DP
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Set Your Hive ",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Font3",
                      ),
                    ),
                    const TextSpan(
                      text: "DP",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Font1",
                        color: AppColors.primaryPink,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "The face everyone's gonna vibe with 👀✨",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  color: isDark ? AppColors.darkText: AppColors.lightText,
                ),
              ),

              const SizedBox(height: 20),

              // DP Upload
              GestureDetector(
                onTap: () => _pickImage(true),
                child: CircleAvatar(
                  radius: size.width * 0.14,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                  backgroundImage: _dp != null ? FileImage(_dp!) : null,
                  child: _dp == null
                      ? const Icon(Icons.add_a_photo,
                      size: 40, color: Colors.grey)
                      : null,
                ),
              ),

              const SizedBox(height: 30),

              // Gallery heading
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Flex Your ",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Font3",
                      ),
                    ),
                    TextSpan(
                      text: "Gallery",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Font1",
                        color: AppColors.secondaryPurple,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 6),
              Text(
                "Drop up to 6 pics that scream this is ME! 🎤🐝 Show your campus fits, your coffee moments ☕, your chaos, your chill. No catfishing 🐟",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  color: isDark ? AppColors.darkText: AppColors.lightText,
                ),
              ),

              const SizedBox(height: 20),

              // Gallery Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 6,
                itemBuilder: (ctx, i) {
                  final img = _gallery[i];
                  return GestureDetector(
                    onTap: () => _pickImage(false, index: i),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        image: img != null
                            ? DecorationImage(
                          image: FileImage(img),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: img == null
                          ? const Icon(Icons.add_photo_alternate,
                          color: Colors.grey, size: 32)
                          : null,
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              AppButton(
                text: "Lock it in ➝",
                backgroundColor: AppColors.primaryYellow,
                textColor: Colors.black,
                width: size.width * 0.6,
                onPressed: _submitAndNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
