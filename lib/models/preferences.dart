import 'dart:math';

import 'package:flutter/material.dart';

class Preferences {
  final String interest;
  Color color =
      Color.fromARGB(200, Random().nextInt(255), Random().nextInt(255), 255);

  Preferences({required this.interest});

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(interest: json['interest']);
  }
  factory Preferences.fromString(String value) {
    return Preferences(interest: value);
  }

  Map<String, dynamic> toJson() {
    return {"interest": interest};
  }
}
