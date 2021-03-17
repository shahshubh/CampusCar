import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String errorText;
  final String labelText;
  final TextEditingController controller;
  final Widget suffixIcon;
  final TextInputType keyboardType;

  CustomInputField({
    this.errorText,
    this.controller,
    this.labelText,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        border: OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
