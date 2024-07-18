import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustumnTextField extends StatelessWidget {
  const CustumnTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.iconName,
    this.keyboardType,
    this.inputFormatters,
  });
  final TextEditingController controller;
  final String hintText;
  final IconData iconName;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Expanded(
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
            hintText: hintText, icon: Icon(iconName), label: Text(hintText)),
      ),
    ));
  }
}
