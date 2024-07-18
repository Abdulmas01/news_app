import 'package:flutter/material.dart';

class CustumnFormField extends StatelessWidget {
  const CustumnFormField(
      {Key? key,
      this.validator,
      this.hintText,
      this.onsave,
      this.autofillHints,
      required this.icon})
      : super(key: key);
  final String? Function(String?)? validator;
  final String? hintText;
  final Function(String?)? onsave;
  final Iterable<String>? autofillHints;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        validator: validator,
        onSaved: onsave,
        autofillHints: autofillHints,
        decoration: InputDecoration(
            hintText: hintText, icon: icon, label: Text(hintText ?? "")),
      ),
    );
  }
}
