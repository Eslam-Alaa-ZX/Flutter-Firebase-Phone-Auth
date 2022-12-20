import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_phone_auth/pages/welcom_page.dart';
import 'package:flutter_firebase_phone_auth/provider/authProvider.dart';
import 'package:flutter_firebase_phone_auth/provider/data.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Data(),),
        ChangeNotifierProvider(create: (context) => AuthProvider(),),
      ],
      child: const MaterialApp(
        title: "FlutterPhoneAuth",
        debugShowCheckedModeBanner: false,
        home: WelcomePage(),
      ),
    );
  }
}
