// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/snackbar_api.dart';
import 'package:news_app/api/storage_api.dart';
import 'package:news_app/enum/account_change_type.dart';

import 'package:news_app/main.dart';
import 'package:news_app/models/user_model.dart' as user_model;

import 'package:news_app/utils/database_collection.dart';
import 'package:news_app/widget/button.dart';
import 'package:news_app/widget/custumn_text_field.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  TextEditingController usernameController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  AccountChangeType accountChangeType = AccountChangeType.none;
  bool changingUserPassword = false;

  void changeUsername() {
    auth.currentUser!.updateDisplayName(usernameController.text);
    user_model.User user = user_model.User(username: usernameController.text);
    db!
        .collection(usersCollection)
        .doc(StorageApi.getUsername())
        .update(user.usernameJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Settings"),
      ),
      body: SizedBox.expand(
        child: Builder(
          builder: (context) {
            switch (accountChangeType) {
              case AccountChangeType.none:
                return Column(
                  children: [
                    ListTile(
                      title: const Text("Change Password"),
                      onTap: () {
                        accountChangeType = AccountChangeType.password;
                        setState(() {});
                      },
                    ),
                  ],
                );
              case AccountChangeType.username:
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CustumnTextField(
                          controller: usernameController,
                          hintText: "Username",
                          iconName: Icons.person),
                      const SizedBox(
                        height: 50,
                      ),
                      Button(text: "submit", callback: changeUsername)
                    ],
                  ),
                );

              case AccountChangeType.password:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: changingUserPassword
                          ? const CircularProgressIndicator()
                          : Button(
                              text: "Send Password Reset",
                              callback: () async {
                                try {
                                  changingUserPassword = true;
                                  setState(() {});
                                  await auth.sendPasswordResetEmail(
                                      email: StorageApi.getEmail());
                                  SnackbarApi(
                                          duration: const Duration(seconds: 6))
                                      .snackbar(
                                          context: context,
                                          text:
                                              "Password Reset Has Been Sent to your Email Address");
                                  changingUserPassword = false;
                                  setState(() {});
                                } on FirebaseAuthException catch (e) {
                                  changingUserPassword = false;
                                  setState(() {});
                                  SnackbarApi()
                                      .snackbar(context: context, text: e.code);
                                }
                              }),
                    )
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
