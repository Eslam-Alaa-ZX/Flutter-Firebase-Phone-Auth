import 'package:flutter/material.dart';
import 'package:flutter_firebase_phone_auth/pages/welcom_page.dart';
import 'package:provider/provider.dart';

import '../provider/authProvider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("FlutterPhone Auth"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(),
                      ),
                    ),
                  );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.purple,
              backgroundImage: NetworkImage(auth.getUserModel.profileImg),
              radius: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(auth.getUserModel.name),
            Text(auth.getUserModel.phone),
            Text(auth.getUserModel.email),
            Text(auth.getUserModel.bio),
          ],
        ),
      ),
    );
  }
}
