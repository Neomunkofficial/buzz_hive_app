import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  Future<void> sendOtp(
      String phoneNumber,
      Function(String verificationId) onCodeSent,
      ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        final userCredential = await _auth.signInWithCredential(credential);
        print("✅ Auto verified. User: ${userCredential.user?.uid}");
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception("OTP verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<UserCredential> verifyOtp(String smsCode, {String? verificationId}) async {
    final id = verificationId ?? _verificationId;
    if (id == null) throw Exception("Verification ID not set. Send OTP first.");

    final credential = PhoneAuthProvider.credential(
      verificationId: id,
      smsCode: smsCode,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    print("✅ OTP verified. User: ${userCredential.user?.uid}");
    return userCredential;
  }

  /// Always get a **fresh Firebase ID token**
  Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user signed in");
    final token = await user.getIdToken(true); // 👈 force refresh
    print("🔑 Got Firebase ID token: $token");
    return token;
  }

  String? get verificationId => _verificationId;
}
