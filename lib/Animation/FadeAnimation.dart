import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';


class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = Tween(begin: 50.0, end: 200.0);

    return PlayAnimationBuilder(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: Duration(seconds: 5),
      tween: tween,
      builder: (BuildContext context, double value, Widget? child) {return  Transform.translate(
          offset: Offset(0, 12),
          child: child
      ); },
      child: child,

    );
  }
}