// presentation/screens/onboarding_flow/onboarding_social_media_linking.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/Colors/AppColors.dart';
import '../../../../state/onboarding_provider.dart';
import '../../../widgets/app_button.dart';
import '../../main_navigation_screen.dart';
import '../onboarding_flow/widgets/onboarding_progress.dart';
import 'onboarding_password_finalscreen.dart';
// NEXT screen: update accordingly
// import 'next_onboarding_screen.dart';

class OnboardingSocialMediaLinkingScreen extends StatefulWidget {
  const OnboardingSocialMediaLinkingScreen({super.key});

  @override
  State<OnboardingSocialMediaLinkingScreen> createState() => _OnboardingSocialMediaLinkingScreenState();
}

class _OnboardingSocialMediaLinkingScreenState extends State<OnboardingSocialMediaLinkingScreen> {
  bool _showSocialOnProfile = true;

  // Map to store social media links
  final Map<String, String> _socialLinks = {
    'linkedin': '',
    'github': '',
    'spotify': '',
    'instagram': '',
    'snapchat': '',
  };

  // Map to track which platforms are connected
  final Map<String, bool> _connectedPlatforms = {
    'linkedin': false,
    'github': false,
    'spotify': false,
    'instagram': false,
    'snapchat': false,
  };

  void _connectSocialMedia(String platform) {
    // Show dialog to enter social media handle/link
    showDialog(
      context: context,
      builder: (context) => _SocialMediaDialog(
        platform: platform,
        initialValue: _socialLinks[platform] ?? '',
        onSave: (value) {
          setState(() {
            _socialLinks[platform] = value;
            _connectedPlatforms[platform] = value.isNotEmpty;
          });
        },
      ),
    );
  }

  void _removeSocialMedia(String platform) {
    setState(() {
      _socialLinks[platform] = '';
      _connectedPlatforms[platform] = false;
    });
  }

  Future<void> _submitAndNext() async {
    final onboarding = context.read<OnboardingProvider>();

    // ✅ Save in provider
    onboarding.setSocialLinks(_socialLinks);
    onboarding.setShowSocialOnProfile(_showSocialOnProfile);

    // ✅ Navigate to next (final or main app)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const OnboardingPasswordScreen(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Social media preferences saved!")),
    );
  }


  void _skipStep() {

    // For now, just show skip message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Social media linking skipped")),
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
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06, // Responsive padding
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OnboardingProgress(step: 8), // Adjust step number as needed

              SizedBox(height: size.height * 0.015),

              // Heading - Left Aligned
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Flex your ",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Font3",
                      ),
                    ),
                    TextSpan(
                      text: "Social vibe",
                      style: TextStyle(
                        fontSize: size.width * 0.1,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Font1",
                        color: AppColors.primaryPink,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),

              SizedBox(height: size.height * 0.015),

              Text(
                "Link your socials & let the hive know\nwhere you buzz around. (Totally optional, btw 😊)",
                textAlign: TextAlign.left,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: size.width * 0.038,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontFamily: "Font3",
                ),
              ),

              SizedBox(height: size.height * 0.03),

              // Social Media Buttons using your AppButton widget with PNG logos
              AppButton(
                text: "LinkedIn",
                backgroundColor: const Color(0xFF0077B5),
                textColor: Colors.white,
                height: size.height * 0.055,
                icon: Stack(
                  children: [
                    // Replace with your 28x28 PNG image
                    Image.asset(
                      'assets/icons/linkedin.png', // Update path as needed
                      width: 28,
                      height: 28,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.work, color: Colors.white, size: 24),
                    ),
                    if (_connectedPlatforms['linkedin']!)
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryPink,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 12),
                        ),
                      ),
                  ],
                ),
                onPressed: () => _connectSocialMedia('linkedin'),
              ),

              SizedBox(height: size.height * 0.012),

              AppButton(
                text: "GitHub",
                backgroundColor: const Color(0xFF6B7280), // Neutral grey that works on both themes
                textColor: Colors.white,
                height: size.height * 0.055,
                icon: Stack(
                  children: [
                    // Replace with your 28x28 PNG image
                    Image.asset(
                      'assets/icons/github.png', // Update path as needed
                      width: 28,
                      height: 28,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.code, color: Colors.white, size: 24),
                    ),
                    if (_connectedPlatforms['github']!)
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryPink,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 12),
                        ),
                      ),
                  ],
                ),
                onPressed: () => _connectSocialMedia('github'),
              ),

              SizedBox(height: size.height * 0.012),

              AppButton(
                text: "Spotify",
                backgroundColor: const Color(0xFF1DB954),
                textColor: Colors.white,
                height: size.height * 0.055,
                icon: Stack(
                  children: [
                    // Replace with your 28x28 PNG image
                    Image.asset(
                      'assets/icons/spotify.png', // Update path as needed
                      width: 28,
                      height: 28,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.music_note, color: Colors.white, size: 24),
                    ),
                    if (_connectedPlatforms['spotify']!)
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryPink,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 12),
                        ),
                      ),
                  ],
                ),
                onPressed: () => _connectSocialMedia('spotify'),
              ),

              SizedBox(height: size.height * 0.012),

              AppButton(
                text: "Instagram",
                backgroundColor: const Color(0xFFE4405F),
                textColor: Colors.white,
                height: size.height * 0.055,
                icon: Stack(
                  children: [
                    // Replace with your 28x28 PNG image
                    Image.asset(
                      'assets/icons/instagram.png', // Update path as needed
                      width: 28,
                      height: 28,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.camera_alt, color: Colors.white, size: 24),
                    ),
                    if (_connectedPlatforms['instagram']!)
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryPink,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 12),
                        ),
                      ),
                  ],
                ),
                onPressed: () => _connectSocialMedia('instagram'),
              ),

              SizedBox(height: size.height * 0.012),

              AppButton(
                text: "Snapchat",
                backgroundColor: const Color(0xFFFFFC00),
                textColor: Colors.black,
                height: size.height * 0.055,
                icon: Stack(
                  children: [
                    // Replace with your 28x28 PNG image
                    Image.asset(
                      'assets/icons/snapchat.png', // Update path as needed
                      width: 28,
                      height: 28,
                      color: Colors.black, // Tint the white PNG to black for yellow background
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.camera, color: Colors.black, size: 24),
                    ),
                    if (_connectedPlatforms['snapchat']!)
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryPink,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 12),
                        ),
                      ),
                  ],
                ),
                onPressed: () => _connectSocialMedia('snapchat'),
              ),

              SizedBox(height: size.height * 0.03),

              // Toggle for showing social media on profile
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(size.width * 0.04),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Flex connected social\nmedia on your profile.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Font3",
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _showSocialOnProfile,
                        onChanged: (value) {
                          setState(() {
                            _showSocialOnProfile = value;
                          });
                        },
                        activeColor: AppColors.primaryPink,
                        activeTrackColor: AppColors.primaryPink.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.03),

              // Skip text
              Center(
                child: GestureDetector(
                  onTap: _skipStep,
                  child: Text(
                    "Don't wanna decide now? no problem\ndo it later.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: size.width * 0.032,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      decoration: TextDecoration.underline,
                      fontFamily: "Font3",
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.025),

              // Continue Button using your AppButton
              Center(
                child: AppButton(
                  text: "Lock it in ➝",
                  backgroundColor: AppColors.primaryYellow,
                  textColor: Colors.black,
                  width: size.width * 0.6,
                  onPressed: _submitAndNext,
                ),
              ),

              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialMediaDialog extends StatefulWidget {
  final String platform;
  final String initialValue;
  final Function(String) onSave;

  const _SocialMediaDialog({
    required this.platform,
    required this.initialValue,
    required this.onSave,
  });

  @override
  State<_SocialMediaDialog> createState() => _SocialMediaDialogState();
}

class _SocialMediaDialogState extends State<_SocialMediaDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getPlaceholderText() {
    switch (widget.platform.toLowerCase()) {
      case 'linkedin':
        return 'LinkedIn profile URL or username';
      case 'github':
        return 'GitHub username';
      case 'spotify':
        return 'Spotify username or profile URL';
      case 'instagram':
        return 'Instagram username';
      case 'snapchat':
        return 'Snapchat username';
      default:
        return 'Enter your ${widget.platform} handle';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Connect ${widget.platform}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: "Font3",
                fontSize: size.width * 0.045,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              'Enter your ${widget.platform} handle or profile URL',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontSize: size.width * 0.035,
                fontFamily: "Font3",
              ),
            ),
            SizedBox(height: size.height * 0.02),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: _getPlaceholderText(),
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: size.width * 0.035,
                  fontFamily: "Font3",
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryPink,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
                contentPadding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.015,
                ),
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: size.width * 0.035,
                fontFamily: "Font3",
              ),
            ),
            SizedBox(height: size.height * 0.025),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppButton(
                  text: 'Cancel',
                  backgroundColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  textColor: isDark ? Colors.white : Colors.black,
                  width: size.width * 0.25,
                  height: size.height * 0.05,
                  fontSize: size.width * 0.035,
                  onPressed: () => Navigator.pop(context),
                ),
                AppButton(
                  text: 'Save',
                  backgroundColor: AppColors.primaryPink,
                  textColor: Colors.white,
                  width: size.width * 0.25,
                  height: size.height * 0.05,
                  fontSize: size.width * 0.035,
                  onPressed: () {
                    widget.onSave(_controller.text.trim());
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}