import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_phone_auth/pages/o_t_p_page.dart';
import 'package:flutter_firebase_phone_auth/utilty/showSnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool isSignedIn = false;

  bool get checkIsSignedIn =>
      isSignedIn; // equel to       bool checkIsSignedIn(){return isSignedIn;}
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    isSignedIn = pref.getBool("signInKey") ?? false;
    notifyListeners();
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPPage(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }
}
