// data/models/user_signup_dto.dart
class UserSignupDto {
  final String phone;
  final String firstName;
  final String lastName;
  final String collegeId;
  final String program;
  final String year;
  final List<String> interests;
  final String? photoUrl; // once uploaded
  final bool acceptedTerms;

  UserSignupDto({
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.collegeId,
    required this.program,
    required this.year,
    required this.interests,
    required this.acceptedTerms,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "firstName": firstName,
    "lastName": lastName,
    "collegeId": collegeId,
    "program": program,
    "year": year,
    "interests": interests,
    "photoUrl": photoUrl,
    "acceptedTerms": acceptedTerms,
  };
}
