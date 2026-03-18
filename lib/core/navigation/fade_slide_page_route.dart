import 'package:flutter/material.dart';

Route<T> fadeSlidePageRoute<T>({
  required Widget child,
  Duration duration = const Duration(milliseconds: 280),
  Curve curve = Curves.easeOut,
}) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, page) {
      final curved = CurvedAnimation(parent: animation, curve: curve);
      final fade = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
      final slide =
          Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero)
              .animate(curved);

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: page),
      );
    },
  );
}

