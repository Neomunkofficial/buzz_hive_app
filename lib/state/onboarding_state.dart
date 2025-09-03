// state/onboarding_state.dart
class OnboardingState {
  final String? backendToken;
  final String phone;
  final String otp;
  final String firstName;
  final String lastName;
  final String? dateOfBirth;    // ADD THIS
  final String? gender;         // ADD THIS
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
    this.dateOfBirth,           // ADD THIS
    this.gender,                // ADD THIS
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
    String? dateOfBirth,        // ADD THIS
    String? gender,             // ADD THIS
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
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,     // ADD THIS
        gender: gender ?? this.gender,                     // ADD THIS
        collegeId: collegeId ?? this.collegeId,
        program: program ?? this.program,
        year: year ?? this.year,
        interests: interests ?? this.interests,
        photoLocalPath: photoLocalPath ?? this.photoLocalPath,
        acceptedTerms: acceptedTerms ?? this.acceptedTerms,
        verificationId: verificationId ?? this.verificationId,
      );

  // ADD THIS METHOD - to get all data for API call
  Map<String, dynamic> getAllOnboardingData() {
    return {
      'name': firstName.isNotEmpty ? firstName : null,
      'dob': dateOfBirth,
      'gender': gender,
      'college_id': collegeId.isNotEmpty ? collegeId : null,
      'department': program.isNotEmpty ? program : null,
      'batch_year': year.isNotEmpty ? int.tryParse(year) : null,
      'interests': interests,
      // Add more fields as needed for other screens
    };
  }
}