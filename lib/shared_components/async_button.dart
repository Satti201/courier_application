import 'package:flutter/material.dart';

class AsyncButton extends StatelessWidget {
  const AsyncButton({
    required this.onPressed,
    required this.child,
    this.style,
    this.circularIndicatorRadius = 15,
  }) ;

  final ButtonStyle? style;
  final Widget? child;
  final Function()? onPressed;

  final double circularIndicatorRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: (onPressed == null ) ? null : onPressed,
      child: child,

    );
  }
}
