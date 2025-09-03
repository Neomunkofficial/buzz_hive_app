// state/onboarding_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'onboarding_state.dart';

class OnboardingProvider extends ChangeNotifier {
  OnboardingState _state = const OnboardingState();
  OnboardingState get state => _state;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _submissionError;
  String? get submissionError => _submissionError;

  void setPhone(String v)         { _state = _state.copyWith(phone: v); notifyListeners(); }
  void setOtp(String v)           { _state = _state.copyWith(otp: v); notifyListeners(); }
  void setFirstName(String v)     { _state = _state.copyWith(firstName: v); notifyListeners(); }
  void setLastName(String v)      { _state = _state.copyWith(lastName: v); notifyListeners(); }
  void setDateOfBirth(String v)   { _state = _state.copyWith(dateOfBirth: v); notifyListeners(); }
  void setGender(String? v)       { _state = _state.copyWith(gender: v); notifyListeners(); }
  void setCollege(String v)       { _state = _state.copyWith(collegeId: v); notifyListeners(); }
  void setProgram(String v)       { _state = _state.copyWith(program: v); notifyListeners(); }
  void setYear(String v)          { _state = _state.copyWith(year: v); notifyListeners(); }
  void toggleInterest(String id)  {
    final list = [..._state.interests];
    list.contains(id) ? list.remove(id) : list.add(id);
    _state = _state.copyWith(interests: list); notifyListeners();
  }
  void setPhotoPath(String? p)    { _state = _state.copyWith(photoLocalPath: p); notifyListeners(); }
  void setConsent(bool v)         { _state = _state.copyWith(acceptedTerms: v); notifyListeners(); }
  void setVerificationId(String id) { _state = _state.copyWith(verificationId: id); notifyListeners(); }
  void setBackendToken(String? t) { _state = _state.copyWith(backendToken: t); notifyListeners(); }

  // Aliases for consistency with your screen code
  void setCollegeId(String v)     => setCollege(v);
  void setDepartmentId(String v)  => setProgram(v);
  void setBatchYear(String v)     => setYear(v);

  /// Submit all onboarding data to backend - call this from your final onboarding screen
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
        'department_id': _state.program.isNotEmpty ? _state.program : null, // Changed to department_id
        'batch_year': _state.year.isNotEmpty ? int.tryParse(_state.year) : null,
        'interests': _state.interests,
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

// state/onboarding_state.dart
class OnboardingState {
  final String? backendToken;
  final String phone;
  final String otp;
  final String firstName;
  final String lastName;
  final String? dateOfBirth;
  final String? gender;
  final String collegeId;
  final String program;
  final String year;
  final List<String> interests;
  final String? photoLocalPath;
  final bool acceptedTerms;
  final String? verificationId;

  const OnboardingState({
    this.backendToken,
    this.phone = '',
    this.otp = '',
    this.firstName = '',
    this.lastName = '',
    this.dateOfBirth,
    this.gender,
    this.collegeId = '',
    this.program = '',
    this.year = '',
    this.interests = const [],
    this.photoLocalPath,
    this.acceptedTerms = false,
    this.verificationId,
  });

  OnboardingState copyWith({
    String? backendToken,
    String? phone,
    String? otp,
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    String? collegeId,
    String? program,
    String? year,
    List<String>? interests,
    String? photoLocalPath,
    bool? acceptedTerms,
    String? verificationId,
  }) =>
      OnboardingState(
        backendToken: backendToken ?? this.backendToken,
        phone: phone ?? this.phone,
        otp: otp ?? this.otp,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        collegeId: collegeId ?? this.collegeId,
        program: program ?? this.program,
        year: year ?? this.year,
        interests: interests ?? this.interests,
        photoLocalPath: photoLocalPath ?? this.photoLocalPath,
        acceptedTerms: acceptedTerms ?? this.acceptedTerms,
        verificationId: verificationId ?? this.verificationId,
      );

  /// Get all data for logging/debugging
  Map<String, dynamic> getAllOnboardingData() {
    return {
      'name': firstName.isNotEmpty ? '${firstName} ${lastName}'.trim() : null,
      'dob': dateOfBirth,
      'gender': gender,
      'college_id': collegeId.isNotEmpty ? collegeId : null,
      'department_id': program.isNotEmpty ? program : null,
      'batch_year': year.isNotEmpty ? int.tryParse(year) : null,
      'interests': interests,
    };
  }
}