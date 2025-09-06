// presentation/screens/onboarding_flow/onboarding_photo_screen.dart

import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:http/http.dart' as http;

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
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
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

  Future<String?> _uploadPhoto(File file, {required bool isDp}) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final phone = context.read<OnboardingProvider>().phone;
      if (token == null) return null;
      if (phone.isEmpty) {
        debugPrint("❌ Phone number missing in provider");
        return null;
      }

      const String baseUrl = "http://192.168.1.10:5000";

      // ✅ mirror I-Card endpoints pattern
      final uri = isDp
          ? Uri.parse("$baseUrl/api/upload/dp/$phone")
          : Uri.parse("$baseUrl/api/upload/photos/$phone");

      final request = http.MultipartRequest("POST", uri)
        ..headers["Authorization"] = "Bearer $token"
        ..files.add(await http.MultipartFile.fromPath("photo", file.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = json.decode(respStr);

        // expect { fileUrl: "/uploads/..." }
        final url = "$baseUrl${data["fileUrl"]}";
        return url;
      } else {
        debugPrint("❌ Upload failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Error uploading photo: $e");
      return null;
    }
  }

  Future<void> _onSubmit() async {
    if (_dp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload a DP")),
      );
      return;
    }

    // 1) Upload DP
    final dpUrl = await _uploadPhoto(_dp!, isDp: true);
    if (dpUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to upload DP")),
      );
      return;
    }

    // 2) Upload gallery (keep 6-slot order)
    final List<String> galleryUrls = List.generate(6, (_) => "");
    for (int i = 0; i < _gallery.length; i++) {
      final file = _gallery[i];
      if (file != null) {
        final url = await _uploadPhoto(file, isDp: false);
        if (url != null) galleryUrls[i] = url;
      }
    }

    // 3) Save ONLY in provider (no DB write here)
    if (!mounted) return;
    final provider = context.read<OnboardingProvider>();
    provider.setDpUrl(dpUrl);
    provider.setGalleryUrls(
      // send only non-empty to backend later, or keep all 6 if you prefer
      galleryUrls.where((u) => u.isNotEmpty).toList(),
    );

    debugPrint("✅ DP URL saved in provider: $dpUrl");
    debugPrint("✅ Gallery URLs saved in provider: ${provider.state.galleryUrls}");

    // 4) Next screen
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OnboardingSocialMediaLinkingScreen()),
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
                onPressed: _onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
