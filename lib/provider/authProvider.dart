import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_phone_auth/model/userModel.dart';
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
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  bool isLoading = false;

  bool get checkIsLoading => isLoading;

  String? userId;

  String get getUserId => userId!;
  UserModel? userModel;

  UserModel get getUserModel => userModel!;

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    isSignedIn = pref.getBool("signInKey") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("signInKey", true);
    isSignedIn = true;
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
    isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otpCode);
      User? user = (await firebaseAuth.signInWithCredential(credential)).user;
      if (user != null) {
        //the logic
        userId = user.uid;
        onIsVerified();
      }
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  Future<bool> checkUserInDB() async {
    DocumentSnapshot snapshot =
        await firebaseFireStore.collection("users").doc(userId).get();
    if (snapshot.exists) {
      print("User Exists");
      return true;
    } else {
      print("New User");
      return false;
    }
  }

  void saveUserInfoInDB({
    required BuildContext context,
    required UserModel user,
    required File picture,
    required Function isDone,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      await storeFileToStorage("profilePic/$userId", picture).then((value) {
        user.profileImg = value;
        user.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
        user.phone = firebaseAuth.currentUser!.phoneNumber!;
        user.userId = firebaseAuth.currentUser!.uid;
      });
      userModel = user;
      await firebaseFireStore
          .collection("users")
          .doc(userId)
          .set(user.toMap())
          .then((value) {
        isDone();
        isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask upload = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await upload;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getDataFromFireStore() async {
    await firebaseFireStore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      userModel = UserModel(
        email: snapshot["email"],
        name: snapshot["name"],
        bio: snapshot["bio"],
        profileImg: snapshot["profileImg"],
        createdAt: snapshot["createdAt"],
        phone: snapshot["phone"],
        userId: snapshot["userId"],
      );
      userId=getUserModel.userId;
    });
  }

  Future saveUserInfoLocal() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString("user", jsonEncode(getUserModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String data = sp.getString("user") ?? "";
    userModel = UserModel.fromMap(jsonDecode(data));
    userId = userModel!.userId;
    notifyListeners();
  }

  Future signOut() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await firebaseAuth.signOut();
    isSignedIn = false;
    notifyListeners();
    sp.clear();
  }
}
