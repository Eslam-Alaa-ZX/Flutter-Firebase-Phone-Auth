import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_phone_auth/utilty/showSnackBar.dart';

class Data with ChangeNotifier {
  Country country = Country(
      phoneCode: "20",
      countryCode: "EG",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Egypt",
      example: "Egypt",
      displayName: "Egypt",
      displayNameNoCountryCode: "EG",
      e164Key: "");
  TextEditingController phoneController = TextEditingController();
  //new user
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  File? img;

  void onCountryChange(Country country) {
    this.country = country;
    notifyListeners();
  }

  void onTextChange(String txt) {
    phoneController.text = txt;//txt.replaceAll(RegExp(r'[^0-9]'), '')
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length),
    );
    notifyListeners();
  }

  void selectImg(BuildContext context) async {
    img=await pickImg(context);
    notifyListeners();
  }
}
