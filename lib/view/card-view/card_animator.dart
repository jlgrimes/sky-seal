import 'package:flutter/material.dart';

enum CardAnimationType { enter, exit }

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
  final CardAnimationType animationType;

  CardAnimator({required this.tickerProvider, required this.animationType}) {
    controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: tickerProvider);
  }

  computeAnimationDetails(
      BuildContext context, RenderBox renderBox, Size size, Offset offset) {
    bool cardIsEntering = (animationType == CardAnimationType.enter);

    // For the zoom in animation
    double scale = 2.2;
    Tween<double> scaleTween;
    if (cardIsEntering) {
      scaleTween = Tween(begin: 1, end: scale);
    } else {
      scaleTween = Tween(begin: scale, end: 1);
    }

    Size windowSize = MediaQuery.of(context).size;

    final double xTranslate = (windowSize.width / 2) - size.width / 2;
    final double yTranslate = (windowSize.height / 2) - size.height / 2;

    Offset startingOffset = Offset(offset.dx, offset.dy);
    Offset finalOffset = Offset(xTranslate, yTranslate);
    Tween<Offset> translateTween;

    if (cardIsEntering) {
      translateTween = Tween(begin: startingOffset, end: finalOffset);
    } else {
      translateTween = Tween(begin: finalOffset, end: startingOffset);
    }

    Animation<Offset> translateAnimation = controller
        .drive(translateTween.chain(CurveTween(curve: Curves.easeOutBack)));
    Animation<double> scaleAnimation = controller
        .drive(scaleTween.chain(CurveTween(curve: Curves.easeOutBack)));

    details = CardAnimationDetails(
        scaleTween: scaleTween,
        translateTween: translateTween,
        scaleAnimation: scaleAnimation,
        translateAnimation: translateAnimation);
  }

  inverseAnimationDetails() {
    Tween<double> scaleTween =
        Tween(begin: details!.scaleTween.end, end: details!.scaleTween.begin);
    Tween<Offset> translateTween = Tween(
        begin: details!.translateTween.end, end: details!.translateTween.begin);

    Animation<Offset> translateAnimation = controller
        .drive(translateTween.chain(CurveTween(curve: Curves.easeOutBack)));
    Animation<double> scaleAnimation = controller
        .drive(scaleTween.chain(CurveTween(curve: Curves.easeOutBack)));

    details = CardAnimationDetails(
        scaleTween: scaleTween,
        translateTween: translateTween,
        scaleAnimation: scaleAnimation,
        translateAnimation: translateAnimation);
  }

  runEnterAnimation() {
    controller.forward().whenCompleteOrCancel(() {
      controller.reset();
    });
  }

  runExitAnimation() {
    inverseAnimationDetails();
    controller.forward().whenCompleteOrCancel(() {
      inverseAnimationDetails();
      controller.reset();
    });
  }
}