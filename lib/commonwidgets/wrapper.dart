import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  final double maxWidth;
  final AlignmentGeometry? alignment;
  final EdgeInsets padding;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  const Wrapper(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.symmetric(horizontal: 10),
      this.maxWidth = 700,
      this.color,
      this.margin,
      this.alignment});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: margin,
        color: color,
        padding: padding,
        alignment: alignment,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
          ),
          child: child,
        ),
      ),
    );
  }
}
