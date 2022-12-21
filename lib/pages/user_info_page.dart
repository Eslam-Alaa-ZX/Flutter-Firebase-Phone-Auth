import 'package:flutter/material.dart';
import 'package:flutter_firebase_phone_auth/widgets/cst_text_field.dart';
import 'package:provider/provider.dart';

import '../provider/authProvider.dart';
import '../provider/data.dart';
import '../widgets/cst_btn.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
          child: Center(
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: data.img == null
                      ? const CircleAvatar(
                          backgroundColor: Colors.purple,
                          radius: 50,
                          child: Icon(
                            Icons.account_circle,
                            size: 50,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                    backgroundImage: FileImage(data.img!),
                    radius: 50,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      CstTextField(hint: "Eslam Alaa", icon: Icons.account_circle, type: TextInputType.name, maxLines: 1, controller: data.nameController),
                      CstTextField(hint: "abc@example.com", icon: Icons.email, type: TextInputType.emailAddress, maxLines: 1, controller: data.emailController),
                      CstTextField(hint: "Enter your bio here...", icon: Icons.edit, type: TextInputType.text, maxLines: 2, controller: data.bioController),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CstBtn(
                          txt: "Login",
                          fun: (){},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
