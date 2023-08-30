import 'package:flutter/material.dart';

class CardAnimationDetails {
  Tween<double> scaleTween;
  Tween<Offset> translateTween;
  Animation<double> scaleAnimation;
  Animation<Offset> translateAnimation;

  CardAnimationDetails(
      {required this.scaleTween,
      required this.translateTween,
      required this.scaleAnimation,
      required this.translateAnimation});
}

class CardAnimator {
  late AnimationController controller;
  CardAnimationDetails? details;
  final TickerProvider tickerProvider;

  CardAnimator({required this.tickerProvider}) {
    controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: tickerProvider);
  }

  computeAnimationDetails(
      BuildContext context, RenderBox renderBox, Size size, Offset offset) {
    // For the zoom in animation
    double scale = 2.2;
    Tween<double> scaleTween = Tween(begin: 1, end: scale);
    Size windowSize = MediaQuery.of(context).size;

    final double xTranslate = (windowSize.width / 2) - size.width / 2;
    final double yTranslate = (windowSize.height / 2) - size.height / 2;

    Offset startingOffset = Offset(offset.dx, offset.dy);
    Offset finalOffset = Offset(xTranslate, yTranslate);
    Tween<Offset> translateTween =
        Tween(begin: startingOffset, end: finalOffset);

    Animation<Offset> translateAnimation = controller
        .drive(translateTween.chain(CurveTween(curve: Curves.easeOutBack)));
    Animation<double> scaleAnimation = controller
        .drive(scaleTween.chain(CurveTween(curve: Curves.easeOutBack)));

    // For the zoom out animation
    scaleTween = Tween(begin: scale, end: 1);
    translateTween = Tween(begin: finalOffset, end: startingOffset);

    details = CardAnimationDetails(
        scaleTween: scaleTween,
        translateTween: translateTween,
        scaleAnimation: scaleAnimation,
        translateAnimation: translateAnimation);
  }
}
