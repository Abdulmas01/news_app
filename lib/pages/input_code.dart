// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/snackbar_api.dart';
import 'package:news_app/enum/inpu_code_type.dart';
import 'package:news_app/widget/button.dart';
import 'package:news_app/widget/custumn_text_field.dart';

class InputCode extends StatefulWidget {
  const InputCode({Key? key, required this.type, this.callback})
      : super(key: key);
  final InputCodeType type;
  final Function(String code)? callback;

  @override
  State<InputCode> createState() => _InputCodeState();
}

class _InputCodeState extends State<InputCode> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(children: [
          CustumnTextField(
              controller: textEditingController,
              hintText: "input Token",
              iconName: Icons.password),
          Button(
              text: "Validate",
              callback: () async {
                switch (widget.type) {
                  case InputCodeType.email:
                  // TODO: Handle this case.
                  case InputCodeType.password:
                    try {
                      await auth
                          .verifyPasswordResetCode(textEditingController.text);
                    } on FirebaseAuthException catch (e) {
                      SnackbarApi().snackbar(context: context, text: e.code);
                    }
                  case InputCodeType.username:
                  // TODO: Handle this case.
                }
              }),
        ]),
      ),
    );
  }
}
