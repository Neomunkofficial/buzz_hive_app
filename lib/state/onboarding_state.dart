// state/onboarding_state.dart
class OnboardingState {
  final String phone;
  final String otp;
  final String firstName;
  final String lastName;
  final String collegeId;
  final String program;
  final String year;
  final List<String> interests;
  final String? photoLocalPath;
  final bool acceptedTerms;

  const OnboardingState({
    this.phone = '',
    this.otp = '',
    this.firstName = '',
    this.lastName = '',
    this.collegeId = '',
    this.program = '',
    this.year = '',
    this.interests = const [],
    this.photoLocalPath,
    this.acceptedTerms = false,
  });

  OnboardingState copyWith({
    String? phone,
    String? otp,
    String? firstName,
    String? lastName,
    String? collegeId,
    String? program,
    String? year,
    List<String>? interests,
    String? photoLocalPath,
    bool? acceptedTerms,
  }) => OnboardingState(
    phone: phone ?? this.phone,
    otp: otp ?? this.otp,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    collegeId: collegeId ?? this.collegeId,
    program: program ?? this.program,
    year: year ?? this.year,
    interests: interests ?? this.interests,
    photoLocalPath: photoLocalPath ?? this.photoLocalPath,
    acceptedTerms: acceptedTerms ?? this.acceptedTerms,
  );
}
