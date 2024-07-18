import 'package:flutter/material.dart';

class NavigationApi {
  static void nextpage({required Widget route, required BuildContext context}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => route,
          transitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween<Offset>(
                    begin: const Offset(-1, 0), end: const Offset(0, 0))
                .animate(
                    CurvedAnimation(parent: animation, curve: Curves.linear));
            return SlideTransition(
              position: tween,
              child: child,
            );
          },
        ));
  }

  static void nextpageParmanent(
      {required Widget route, required BuildContext context}) {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => route,
          transitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween<Offset>(
                    begin: const Offset(-1, 0), end: const Offset(0, 0))
                .animate(
                    CurvedAnimation(parent: animation, curve: Curves.linear));
            return SlideTransition(
              position: tween,
              child: child,
            );
          },
        ));
  }

  static Future nextPageWithResult(
      {required Widget route, required BuildContext context}) {
    return Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => route,
          transitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween<Offset>(
                    begin: const Offset(-1, 0), end: const Offset(0, 0))
                .animate(
                    CurvedAnimation(parent: animation, curve: Curves.linear));
            return SlideTransition(
              position: tween,
              child: child,
            );
          },
        ));
  }

  static Future nextpageFromNavigator(
      {required Widget route, required NavigatorState navigator}) {
    return navigator.push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => route,
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
                begin: const Offset(-1, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(parent: animation, curve: Curves.linear));
        return SlideTransition(
          position: tween,
          child: child,
        );
      },
    ));
  }

  static Future nextpageParmanentFromNavigator(
      {required Widget route, required NavigatorState navigator}) {
    return navigator.push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => route,
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
                begin: const Offset(-1, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(parent: animation, curve: Curves.linear));
        return SlideTransition(
          position: tween,
          child: child,
        );
      },
    ));
  }
}
