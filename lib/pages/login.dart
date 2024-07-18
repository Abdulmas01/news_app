// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/api/snackbar_api.dart';
import 'package:news_app/api/storage_api.dart';
import 'package:news_app/models/user_model.dart' as user_model;
import 'package:news_app/pages/main_pages.dart';
import 'package:news_app/style/text_style.dart';
import 'package:news_app/widget/button.dart';
import 'package:news_app/widget/custumn_form_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  String? username, email;
  dynamic password;

  final FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;
  Future<void> login() async {
    FormState? form = formkey.currentState;

    try {
      if (form!.validate()) {
        loading = true;
        setState(() {});
        form.save();
        await auth.signInWithEmailAndPassword(
            email: email!, password: password!);
        user_model.User user =
            await user_model.User.userfromDb(email: email!, password: password);
        StorageApi.setUserCreadential(username: user.username, email: email!);
        StorageApi.setPrefference(user.userPrefference);
        StorageApi.setLoggedin(true);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPages(),
            ));
      }
    } on FirebaseAuthException catch (e) {
      loading = false;
      SnackbarApi()
          .snackbar(context: context, text: e.message ?? "fail to login");
      setState(() {});
    } on Exception catch (e) {
      loading = false;
      SnackbarApi(duration: const Duration(seconds: 5))
          .snackbar(text: e.toString(), context: context);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: formkey,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: size.height * .4,
                width: size.width,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 35, 71, 82),
                  Colors.green
                ])),
                child: const Text(
                  "News Feed App",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign in", style: headerStyle),
                      CustumnFormField(
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return value.isEmail
                                  ? null
                                  : "please insert a valid email";
                            } else {
                              return "email is required";
                            }
                          },
                          hintText: "Email",
                          icon: const Icon(Icons.alternate_email),
                          autofillHints: const [AutofillHints.email],
                          onsave: (value) => email = value),
                      CustumnFormField(
                          validator: (value) =>
                              value!.isEmpty ? "password is required" : null,
                          hintText: "password",
                          icon: const Icon(Icons.lock_outlined),
                          onsave: (value) => password = value),
                      const SizedBox(
                        height: 20,
                      ),
                      AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: loading
                              ? const CircularProgressIndicator()
                              : Button(text: "Submit", callback: login)),
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
