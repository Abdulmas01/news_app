import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {super.key,
      required this.text,
      required this.callback,
      this.argument,
      this.margin,
      this.padding,
      this.width,
      this.height,
      this.alignment,
      this.leadingIcon,
      this.traillingIcon,
      this.color});
  final String text;
  final Function callback;
  final Object? argument;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Alignment? alignment;
  final IconData? leadingIcon;
  final IconData? traillingIcon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        argument == null ? callback() : callback(argument);
      },
      child: Container(
        width: width ?? 200,
        height: height ?? 45,
        alignment: alignment ?? Alignment.center,
        margin: margin ?? const EdgeInsets.only(top: 9),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        decoration: BoxDecoration(
            // gradient: const LinearGradient(colors: [
            //   Colors.white,
            //   Color.fromARGB(255, 130, 130, 115),
            // ]),
            color: color ?? Colors.blue.shade300,
            borderRadius: BorderRadius.circular(9)),
        child: leadingIcon == null && traillingIcon == null
            ? Text(
                text,
              )
            : Row(
                children: [
                  if (leadingIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(leadingIcon),
                    ),
                  Text(text),
                  if (traillingIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Icon(traillingIcon),
                    )
                ],
              ),
      ),
    );
  }
}
