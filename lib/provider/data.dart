import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

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

  void onCountryChange(Country country) {
    this.country = country;
    notifyListeners();
  }

  void onTextChange(String txt) {
    phoneController.text = txt;
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length),
    );
    notifyListeners();
  }
}
