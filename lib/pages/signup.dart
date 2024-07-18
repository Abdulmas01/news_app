import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/api/navigation_api.dart';
import 'package:news_app/api/snackbar_api.dart';
import 'package:news_app/api/storage_api.dart';
import 'package:news_app/models/user_model.dart' as user_model;
import 'package:news_app/pages/login.dart';
import 'package:news_app/pages/preferences_page.dart';
import 'package:news_app/style/colors.dart';
import 'package:news_app/style/text_style.dart';
import 'package:news_app/widget/button.dart';
import 'package:news_app/widget/custumn_form_field.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formkey = GlobalKey<FormState>();
  bool loading = false;
  bool showPassword = false;
  String? username, email;
  dynamic password, confirmPassword;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signUp() async {
    FormState? form = formkey.currentState;
    if (form!.validate()) {
      form.save();
      try {
        user_model.User user =
            user_model.User(username: username!, email: email);
        if (!user.vallidatePassword(
            password: password, confirmPassword: confirmPassword)) {
          SnackbarApi(duration: const Duration(seconds: 3))
              .snackbar(context: context, text: "password miss-match");
          return;
        }
        loading = true;
        setState(() {});

        await user.registerNewUser(password: password);
        StorageApi.setUserCreadential(username: username!, email: email!);
        StorageApi.setLoggedin(true);
        // ignore: use_build_context_synchronously
        NavigationApi.nextpageParmanent(
            route: const PreferencesPage(), context: context);
      } on FirebaseAuthException catch (e) {
        loading = false;
        // ignore: use_build_context_synchronously
        SnackbarApi(duration: const Duration(seconds: 5))
            .snackbar(text: e.message ?? "failed", context: context);
        setState(() {});
      } on Exception catch (e) {
        // ignore: use_build_context_synchronously
        SnackbarApi(duration: const Duration(seconds: 5))
            .snackbar(text: e.toString(), context: context);
        setState(() {});
      }
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
                      children: [
                        Text(
                          "Sign up",
                          style: headerStyle,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustumnFormField(
                            validator: (value) =>
                                value!.isEmpty ? "username is required" : null,
                            hintText: "username",
                            icon: const Icon(Icons.person_outline),
                            autofillHints: const [AutofillHints.username],
                            onsave: (value) => username = value),
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
                        CustumnFormField(
                            validator: (value) => value!.isEmpty
                                ? "confirm password is required"
                                : null,
                            hintText: "confirm password",
                            icon: const Icon(Icons.lock_outlined),
                            onsave: (value) => confirmPassword = value),
                        const SizedBox(
                          height: 20,
                        ),
                        AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: loading
                                ? const CircularProgressIndicator()
                                : Button(text: "Submit", callback: signUp)),
                        const SizedBox(
                          height: 20,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Already have an account? ",
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: "login",
                                    style:
                                        const TextStyle(color: importantColor),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        NavigationApi.nextpageParmanent(
                                            route: const Login(),
                                            context: context);
                                      })
                              ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
