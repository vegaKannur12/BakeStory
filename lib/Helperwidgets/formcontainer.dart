
import 'package:flutter/material.dart';

class FormContainer extends StatelessWidget {
  final double maxWidth;
  const FormContainer({super.key, required this.child, this.maxWidth = 450});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: const Color.fromARGB(31, 51, 48, 48),
            border: Border.all(width: 0.25, color: Color.fromARGB(255, 48, 47, 47)),
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: child);
  }
}
