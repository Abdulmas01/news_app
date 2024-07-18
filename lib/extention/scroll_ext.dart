import 'package:flutter/material.dart';

extension ScrollControllerExt on ScrollController {
  bool get isEndOfList => position.extentAfter < 50;
  bool get isReFetchRange =>
      position.extentAfter <= 150 && position.extentAfter >= 100;
}
