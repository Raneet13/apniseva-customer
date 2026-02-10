//features/dashboard/sections/dash_reviews.dart
import 'package:flutter/material.dart';

class AppTextInput extends StatelessWidget {
  final TextEditingController controller;

  final TextInputType keyboardType;

  final String hintText;

  const AppTextInput({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}
