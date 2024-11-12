import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Color? color;
  final Color? hintColor;
  final Color? enteredTextColor;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final EdgeInsets? contentPadding;
  final Color? cursorColor;
  final bool? obscureText;
  final TextInputType? keyboardType;
  const DefaultTextField({
    super.key,
    this.controller,
    this.hintText,
    this.color,
    this.hintColor,
    this.enteredTextColor,
    this.onChanged,
    this.suffixIcon,
    this.contentPadding,
    this.cursorColor,
    this.obscureText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        cursorColor: cursorColor,
        style: TextStyle(
          color: enteredTextColor,
        ),
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          suffix: suffixIcon,
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          contentPadding: contentPadding ?? const EdgeInsets.only(left: 10),
        ),
      ),
    );
  }
}
