import 'package:flutter/material.dart';

class GradientColorContainer extends StatelessWidget {
  const GradientColorContainer({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(184, 165, 165, 0.925),
            Color.fromARGB(255, 63, 61, 61),
          ],
          stops: [0.112, 0.789],
        ),
      ),
      child: child,
    );
  }
}
