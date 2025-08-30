// state/onboarding_provider.dart
import 'package:flutter/material.dart';
import 'onboarding_state.dart';

class OnboardingProvider extends ChangeNotifier {
  OnboardingState _state = const OnboardingState();
  OnboardingState get state => _state;

  void setPhone(String v)     { _state = _state.copyWith(phone: v); notifyListeners(); }
  void setOtp(String v)       { _state = _state.copyWith(otp: v); notifyListeners(); }
  void setFirstName(String v) { _state = _state.copyWith(firstName: v); notifyListeners(); }
  void setLastName(String v)  { _state = _state.copyWith(lastName: v); notifyListeners(); }
  void setCollege(String v)   { _state = _state.copyWith(collegeId: v); notifyListeners(); }
  void setProgram(String v)   { _state = _state.copyWith(program: v); notifyListeners(); }
  void setYear(String v)      { _state = _state.copyWith(year: v); notifyListeners(); }
  void toggleInterest(String id) {
    final list = [..._state.interests];
    list.contains(id) ? list.remove(id) : list.add(id);
    _state = _state.copyWith(interests: list); notifyListeners();
  }
  void setPhotoPath(String? p){ _state = _state.copyWith(photoLocalPath: p); notifyListeners(); }
  void setConsent(bool v)     { _state = _state.copyWith(acceptedTerms: v); notifyListeners(); }

  void reset() { _state = const OnboardingState(); notifyListeners(); }
}
