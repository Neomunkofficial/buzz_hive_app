// state/onboarding_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'onboarding_state.dart';

// state/onboarding_provider.dart

class OnboardingProvider extends ChangeNotifier {
  OnboardingState _state = const OnboardingState();
  OnboardingState get state => _state;

  String get phone => _state.phone;


  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _submissionError;
  String? get submissionError => _submissionError;

  // ------------------- SETTERS -------------------
  void setPhone(String v)         { _state = _state.copyWith(phone: v); notifyListeners(); }
  void setOtp(String v)           { _state = _state.copyWith(otp: v); notifyListeners(); }
  void setFirstName(String v)     { _state = _state.copyWith(firstName: v); notifyListeners(); }
  void setLastName(String v)      { _state = _state.copyWith(lastName: v); notifyListeners(); }
  void setDateOfBirth(String v)   { _state = _state.copyWith(dateOfBirth: v); notifyListeners(); }
  void setGender(String? v)       { _state = _state.copyWith(gender: v); notifyListeners(); }
  void setCollege(String v)       { _state = _state.copyWith(collegeId: v); notifyListeners(); }
  void setProgram(String v)       { _state = _state.copyWith(program: v); notifyListeners(); }
  void setYear(String v)          { _state = _state.copyWith(year: v); notifyListeners(); }
  void toggleInterest(String id)  {final list = [..._state.interests];list.contains(id) ? list.remove(id) : list.add(id);_state = _state.copyWith(interests: list); notifyListeners();}
  void setPhotoPath(String? p)    { _state = _state.copyWith(photoLocalPath: p); notifyListeners(); }
  void setConsent(bool v)         { _state = _state.copyWith(acceptedTerms: v); notifyListeners(); }
  void setVerificationId(String id) { _state = _state.copyWith(verificationId: id); notifyListeners(); }
  void setBackendToken(String? t) { _state = _state.copyWith(backendToken: t); notifyListeners(); }

  // ✅ NEW METHODS for I-Card
  void setFrontICardUrl(String url) {_state = _state.copyWith(frontICardUrl: url);notifyListeners();}
  void setBackICardUrl(String url) {_state = _state.copyWith(backICardUrl: url);notifyListeners();}

  // ✅ NEW METHODS for Intrests
  void setInterests(List<String> list) {_state = _state.copyWith(interests: list);debugPrint("✅ Interests stored in provider: ${_state.interests}");notifyListeners();}

  // ✅ NEW METHODS for Photoes upload
  void setDpUrl(String url) {_state = _state.copyWith(dpUrl: url);debugPrint("✅ DP URL stored in provider: $url");notifyListeners();}
  void setGalleryUrls(List<String> urls) {_state = _state.copyWith(galleryUrls: urls);debugPrint("✅ Gallery URLs stored in provider: $urls");notifyListeners();}
  void removeGalleryUrl(String url) {final list = [..._state.galleryUrls]..remove(url);_state = _state.copyWith(galleryUrls: list);notifyListeners();}

  // ✅ New methods for socials
  void setSocialLinks(Map<String, String> links) { _state = _state.copyWith(socialLinks: links);debugPrint("✅ Social links stored in provider: $links");notifyListeners();}
  void updateSocialLink(String platform, String url) {final newLinks = {..._state.socialLinks, platform: url}; _state = _state.copyWith(socialLinks: newLinks);debugPrint("✅ Updated social link: $platform -> $url");notifyListeners();}
  void removeSocialLink(String platform) {final newLinks = {..._state.socialLinks};newLinks.remove(platform);_state = _state.copyWith(socialLinks: newLinks);debugPrint("✅ Removed social link: $platform");notifyListeners();}
  void setShowSocialOnProfile(bool value) {_state = _state.copyWith(showSocialOnProfile: value);debugPrint("✅ Show social on profile: $value");notifyListeners();}

  // ✅ New methods for email and pass
  void setEmail(String v) {_state = _state.copyWith(email: v);notifyListeners();}
  void setPassword(String v) {_state = _state.copyWith(password: v);notifyListeners();}



  // Aliases for consistency with your screen code
  void setCollegeId(String v)     => setCollege(v);
  void setDepartmentId(String v)  => setProgram(v);
  void setBatchYear(String v)     => setYear(v);

  /// Submit all onboarding data to backend
  Future<bool> submitOnboardingData() async {
    _isSubmitting = true;
    _submissionError = null;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not authenticated");
      }

      final token = await user.getIdToken();

      // Prepare the data payload
      final payload = {
        'name': '${_state.firstName} ${_state.lastName}'.trim(),
        'dob': _state.dateOfBirth,
        'gender': _state.gender,
        'college_id': _state.collegeId.isNotEmpty ? _state.collegeId : null,
        'department_id': _state.program.isNotEmpty ? _state.program : null,
        'batch_year': _state.year.isNotEmpty ? int.tryParse(_state.year) : null,
        'interests': _state.interests,
        // ✅ Include uploaded I-Card URLs
        'front_icard_url': _state.frontICardUrl,
        'back_icard_url': _state.backICardUrl,
        'dp': _state.dpUrl,
        'photos': _state.galleryUrls.isNotEmpty ? _state.galleryUrls : null,
        'socials': _state.socialLinks.isNotEmpty ? _state.socialLinks : null,
        'show_social_on_profile': _state.showSocialOnProfile,
        'email': _state.email,
        'password': _state.password,
      };

      print("🚀 Submitting onboarding data:");
      print("📋 Payload: $payload");

      final response = await http.patch(
        Uri.parse("http://192.168.1.10:5000/api/users/onboarding"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      print("📡 Response Status: ${response.statusCode}");
      print("📡 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Onboarding submission successful: ${data['message']}");

        _isSubmitting = false;
        notifyListeners();
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData["error"] ?? "Failed to submit onboarding data");
      }

    } catch (e) {
      print("❌ Error submitting onboarding data: $e");
      _submissionError = e.toString();
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  void clearSubmissionError() {
    _submissionError = null;
    notifyListeners();
  }

  void reset() {
    _state = const OnboardingState();
    _isSubmitting = false;
    _submissionError = null;
    notifyListeners();
  }
}