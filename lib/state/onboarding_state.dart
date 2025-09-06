// state/onboarding_state.dart
class OnboardingState {
  final String? backendToken;
  final String phone;
  final String otp;
  final String? frontICardUrl;
  final String? backICardUrl;
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
  final String? dpUrl;
  final List<String> galleryUrls;
  final Map<String, String> socialLinks;
  final bool showSocialOnProfile;
  final String? email;
  final String? password;

  const OnboardingState({
    this.backendToken,
    this.phone = '',
    this.otp = '',
    this.frontICardUrl,
    this.backICardUrl,
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
    this.dpUrl,
    this.galleryUrls = const [],
    this.socialLinks = const {},
    this.showSocialOnProfile = true,
    this.email,
    this.password,
  });

  OnboardingState copyWith({
    String? backendToken,
    String? phone,
    String? otp,
    String? frontICardUrl,
    String? backICardUrl,
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
    String? dpUrl,
    List<String>? galleryUrls,
    Map<String, String>? socialLinks,
    bool? showSocialOnProfile,
    String? email,
    String? password,
  }) =>
      OnboardingState(
        backendToken: backendToken ?? this.backendToken,
        phone: phone ?? this.phone,
        otp: otp ?? this.otp,
        frontICardUrl: frontICardUrl ?? this.frontICardUrl,
        backICardUrl: backICardUrl ?? this.backICardUrl,
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
        dpUrl: dpUrl ?? this.dpUrl,
        galleryUrls: galleryUrls ?? this.galleryUrls,
        socialLinks: socialLinks ?? this.socialLinks,
        showSocialOnProfile: showSocialOnProfile ?? this.showSocialOnProfile,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  Map<String, dynamic> getAllOnboardingData() {
    return {
      'name': firstName.isNotEmpty ? '${firstName} ${lastName}'.trim() : null,
      'dob': dateOfBirth,
      'gender': gender,
      'college_id': collegeId.isNotEmpty ? collegeId : null,
      'department_id': program.isNotEmpty ? program : null,
      'batch_year': year.isNotEmpty ? int.tryParse(year) : null,
      'interests': interests,
      'front_icard_url': frontICardUrl,
      'back_icard_url': backICardUrl,
      "dp": dpUrl,
      "photos": galleryUrls,
      "socials": socialLinks,
      "show_social_on_profile": showSocialOnProfile,
      'email': email,
      'password': password != null ? "******" : null, // mask password
    };
  }
}
