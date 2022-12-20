import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool isSignedIn = false;

  bool get checkIsSignedIn => isSignedIn; // equel to       bool checkIsSignedIn(){return isSignedIn;}

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    isSignedIn = pref.getBool("signInKey") ?? false;
    notifyListeners();
  }
}
