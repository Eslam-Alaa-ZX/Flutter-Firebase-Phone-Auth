import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_phone_auth/provider/data.dart';
import 'package:provider/provider.dart';


import '../provider/authProvider.dart';
import '../widgets/cst_btn.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple.shade50,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Image.asset("assets/2.png"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Add your phone number. We'll send you a verification code.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: data.phoneController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      data.onTextChange(value);
                    },
                    cursorColor: Colors.purple,
                    decoration: InputDecoration(
                      hintText: "Enter phone number",
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      prefixIcon: Container(
                        padding:
                            const EdgeInsets.only(top: 12, left: 8, right: 8),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              onSelect: (value) {
                                data.onCountryChange(value);
                              },
                              countryListTheme: const CountryListThemeData(
                                bottomSheetHeight: 500,
                              ),
                            );
                          },
                          child: Text(
                            "${data.country.flagEmoji} + ${data.country.phoneCode}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      suffixIcon: data.phoneController.text.replaceAll(RegExp(r'[^0-9]'), '').length > 9
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CstBtn(
                      txt: "Login",
                      fun: () => checkPhoneNumber(context, data, auth),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void checkPhoneNumber(BuildContext context,Data da,AuthProvider ap){
    String phoneNumber=da.phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
    ap.signInWithPhone(context, "+${da.country.phoneCode}$phoneNumber");

  }
}
