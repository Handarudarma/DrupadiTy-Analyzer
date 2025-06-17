import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final Logger logger = Logger();

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final GoogleSignIn _googleSignIn = kIsWeb
      ? GoogleSignIn(
          clientId:
              '425004809724-177h21rjkhn10hrsemipco7jpeg57o44.apps.googleusercontent.com',
        )
      : GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      logger.i("Login berhasil untuk user: ${userCredential.user?.email}");

      return userCredential;
    } catch (e, stackTrace) {
      logger.e("Login gagal", error: e, stackTrace: stackTrace);
      return null;
    }
  }

  Future<UserCredential?> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);

      logger.i("Registrasi berhasil untuk user: ${userCredential.user?.email}");
      return userCredential;
    } catch (e, stackTrace) {
      logger.e("Registrasi gagal", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      logger.i("Login berhasil untuk user: ${userCredential.user?.email}");
      return userCredential;
    } catch (e, stackTrace) {
      logger.e("Login dengan email gagal", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
