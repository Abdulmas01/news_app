import 'package:flutter/material.dart';
import 'package:news_app/api/navigation_api.dart';
import 'package:news_app/pages/login.dart';

class ResponseModel implements Exception {
  final int statusCode;
  final bool sucessfull;
  final dynamic body;
  final String? errorType;
  final String? message;

  ResponseModel({
    required this.statusCode,
    required this.sucessfull,
    this.body,
    this.errorType,
    this.message,
  });

  bool get isAuthenticated => statusCode != 401;
  void logoutUnautenticated(BuildContext context) {
    if (!isAuthenticated) {
      NavigationApi.nextPageWithResult(route: const Login(), context: context);
    }
  }
}
