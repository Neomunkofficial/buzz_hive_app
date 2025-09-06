import 'dart:convert';
import 'dart:io';
import 'package:buzz_hive_app/presentaion/screens/onboarding/onboarding_flow/widgets/onboarding_progress.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../../../config/Colors/AppColors.dart';
import '../../../../state/onboarding_provider.dart';
import '../../../widgets/app_button.dart';
import 'onboarding_interests_screen.dart';

class OnboardingICardScreen extends StatefulWidget {
  const OnboardingICardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingICardScreen> createState() => _OnboardingICardScreenState();
}

class _OnboardingICardScreenState extends State<OnboardingICardScreen> {
  File? _frontImage;
  File? _backImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isFront) async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        if (isFront) {
          _frontImage = File(picked.path);
        } else {
          _backImage = File(picked.path);
        }
      });
    }
  }

  Future<String?> _uploadICard(File file) async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final phone = context.read<OnboardingProvider>().phone;

      if (phone.isEmpty) {
        debugPrint("❌ Phone number is missing in OnboardingProvider");
        return null;
      }

      const String baseUrl = "http://192.168.1.10:5000";
      final uri = Uri.parse("$baseUrl/api/upload/icard/$phone");

      final request = http.MultipartRequest("POST", uri)
        ..headers["Authorization"] = "Bearer $token"
        ..files.add(await http.MultipartFile.fromPath("icard", file.path));

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(respStr);
        if (data["fileUrl"] != null) {
          final url = "$baseUrl${data["fileUrl"]}";
          debugPrint("✅ Uploaded I-Card: $url");
          return url;
        } else {
          debugPrint("❌ Missing fileUrl in response: $respStr");
          return null;
        }
      } else {
        debugPrint("❌ Upload failed ${response.statusCode} $respStr");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Error uploading I-Card: $e");
      return null;
    }
  }

  void _onSubmit() async {
    if (_frontImage == null || _backImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload both sides of your I-Card")),
      );
      return;
    }

    setState(() {}); // to trigger loading state if you add it later

    final frontUrl = await _uploadICard(_frontImage!);
    final backUrl = await _uploadICard(_backImage!);

    if (frontUrl != null && backUrl != null && mounted) {
      final provider = Provider.of<OnboardingProvider>(context, listen: false);
      provider.setFrontICardUrl(frontUrl);
      provider.setBackICardUrl(backUrl);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const OnboardingInterestsScreen(
            interests: ["Music",
              "Dance",
              "Sports",
              "Coding",
              "Design",
              "Photography",], // same interests list
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to upload I-Card")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const OnboardingProgress(step: 5),
              const SizedBox(height: 30),
              SizedBox(
                height: size.height * 0.26,
                child: Image.asset(
                  "assets/images/icard_screen_image.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Only real students in Hive\n",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Font3",
                      ),
                    ),
                    const TextSpan(
                      text: "No fakes allowed",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Font1",
                        color: AppColors.primaryPink,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                "Verified users get the cool blue check ✅ next to their name",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _UploadBox(
                    label: "Upload Front",
                    file: _frontImage,
                    onTap: () => _pickImage(true),
                  ),
                  _UploadBox(
                    label: "Upload Back",
                    file: _backImage,
                    onTap: () => _pickImage(false),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              AppButton(
                text: "Lock it in ➝",
                backgroundColor: AppColors.primaryYellow,
                textColor: AppColors.lightText,
                width: size.width * 0.5,
                onPressed: _onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ----- Upload Box Widget -----
class _UploadBox extends StatelessWidget {
  final String label;
  final File? file;
  final VoidCallback onTap;

  const _UploadBox({
    Key? key,
    required this.label,
    required this.file,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: size.width * 0.3,
            width: size.width * 0.3,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
              image: file != null
                  ? DecorationImage(
                image: FileImage(file!),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: file == null
                ? const Icon(Icons.add_a_photo,
                size: 32, color: Colors.black54)
                : null,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: "Font3",
              fontSize: 14,
              color: AppColors.lightText,
            ),
          ),
        ),
      ],
    );
  }
}
