import 'package:flutter/material.dart';
import 'package:flutter_firebase_phone_auth/pages/welcom_page.dart';
import 'package:flutter_firebase_phone_auth/provider/data.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: const MaterialApp(
        title: "FlutterPhoneAuth",
        debugShowCheckedModeBanner: false,
        home: WelcomPage(),
      ),
    );
  }
}
