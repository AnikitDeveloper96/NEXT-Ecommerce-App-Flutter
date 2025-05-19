import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nextecommerceapp/screens/mainhomepage.dart';

class Authentication {
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      try {
        final UserCredential userCredential = await auth.signInWithPopup(
          authProvider,
        );
        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential = await auth.signInWithCredential(
            credential,
          );
          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }
    if (user != null) {
      // Navigate to MainHomepage after successful sign-in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainHomePage(user: user)),
      );
    }
    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(customSnackBar(content: 'Error signing out. Try again.'));
    }
  }

  static Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainHomePage(user: user)),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(customSnackBar(content: e.message ?? 'Sign up failed'));
    }
  }

  static Future<void> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainHomePage(user: user)),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(customSnackBar(content: e.message ?? 'Sign in failed'));
    }
  }

  static Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(customSnackBar(content: 'Password reset email sent'));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(customSnackBar(content: 'Error sending reset email'));
    }
  }
}
