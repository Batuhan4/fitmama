import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Wraps Firebase Auth with only Google + Apple providers.
/// No email/password, no anonymous sign-in — per product decision.
class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _googleInited = false;

  Future<void> ensureGoogleInit() async {
    if (kIsWeb || _googleInited) return;
    try {
      await GoogleSignIn.instance.initialize();
      _googleInited = true;
    } catch (e) {
      debugPrint('GoogleSignIn init failed: $e');
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        return await _auth.signInWithPopup(GoogleAuthProvider());
      }
      await ensureGoogleInit();
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      return null;
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      return await _auth.signInWithCredential(oauthCredential);
    } catch (e) {
      debugPrint('Apple sign-in error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      if (!kIsWeb && _googleInited) {
        await GoogleSignIn.instance.signOut();
      }
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign-out error: $e');
    }
  }
}
