import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_phone_auth/pages/o_t_p_page.dart';
import 'package:flutter_firebase_phone_auth/utilty/showSnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool isSignedIn = false;
  String? otpCode;

  bool get checkIsSignedIn =>
      isSignedIn; // equel to       bool checkIsSignedIn(){return isSignedIn;}
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  bool isLoading = false;
  bool get checkIsLoading => isLoading;

  String? userId;
String get getUserId => userId!;

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

  void checkOtpCode({
    required BuildContext context,
    required String verificationId,
    required String otpCode,
    required Function onIsVerified,
  }) async {
    isLoading=true;
    notifyListeners();

    try{
      PhoneAuthCredential credential=PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpCode);
      User? user= (await firebaseAuth.signInWithCredential(credential)).user;
      if(user != null){
        //the logic
        userId=user.uid;
        onIsVerified();
      }
      isLoading=false;
      notifyListeners();
    } on FirebaseAuthException catch(e){
      showSnackBar(context, e.message.toString());
    }
  }

  Future<bool> checkUserInDB() async {
    DocumentSnapshot snapshot=await firebaseFireStore.collection("users").doc(userId).get();
    if(snapshot.exists){
      print("User Exists");
      return true;
    }
    else{
      print("New User");
      return false;
    }
  }
}
