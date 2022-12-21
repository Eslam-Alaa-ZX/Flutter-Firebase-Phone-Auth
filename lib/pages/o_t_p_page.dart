import 'package:flutter/material.dart';
import 'package:flutter_firebase_phone_auth/pages/user_info_page.dart';
import 'package:flutter_firebase_phone_auth/utilty/showSnackBar.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../provider/authProvider.dart';
import '../provider/data.dart';
import '../widgets/cst_btn.dart';

class OTPPage extends StatelessWidget {
  final String verificationId;

  const OTPPage({Key? key, required this.verificationId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: auth.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 25),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple.shade50,
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Image.asset("assets/3r.png"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Verification",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Enter the OTP send to your phone number.",
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
                        Pinput(
                          length: 6,
                          showCursor: true,
                          defaultPinTheme: PinTheme(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.purple.shade200),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onCompleted: (value) {
                            auth.otpCode = value;
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: CstBtn(
                            txt: "Verify",
                            fun: () {
                              if (auth.otpCode != null) {
                                verifyOtp(context, auth.otpCode!, auth);
                              } else {
                                showSnackBar(context, "Enter 6-Digit code");
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Didn't receive any code?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Resend New Code",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
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

  void verifyOtp(BuildContext context, String otpCode, AuthProvider ap) {
    ap.checkOtpCode(
      context: context,
      verificationId: verificationId,
      otpCode: otpCode,
      onIsVerified: () {
        // check the user in database
        ap.checkUserInDB().then((value) async {
          if(value){

          }else{
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const UserInfoPage(),), (route) => false);
          }
        });
      },
    );
  }
}
