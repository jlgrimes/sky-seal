import 'package:flutter/material.dart';
import 'package:sky_seal/view/card-view/constants.dart';

enum CardAnimationType { enter, exit }

const bottomAppBarOffset = 0.0;

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
        duration: const Duration(milliseconds: 300), vsync: tickerProvider);
  }

  computeAnimationDetails(
      BuildContext context, RenderBox renderBox, Size size, Offset offset) {
    bool cardIsEntering = (animationType == CardAnimationType.enter);

    // For the zoom in animation
    double scale = desiredFinalWidth / size.width;
    Tween<double> scaleTween;
    if (cardIsEntering) {
      scaleTween = Tween(begin: 1, end: scale);
    } else {
      scaleTween = Tween(begin: scale, end: 1);
    }

    Size windowSize = MediaQuery.of(context).size;

    final double xTranslate = (windowSize.width / 2) - size.width / 2;
    final double yTranslate =
        (windowSize.height / 2) - size.height / 2 - bottomAppBarOffset;

    Offset startingOffset = Offset(offset.dx, offset.dy);
    Offset finalOffset = Offset(xTranslate, yTranslate);
    Tween<Offset> translateTween;

    if (cardIsEntering) {
      translateTween = Tween(begin: startingOffset, end: finalOffset);
    } else {
      translateTween = Tween(begin: finalOffset, end: startingOffset);
    }

    Animation<Offset> translateAnimation = controller
        .drive(translateTween.chain(CurveTween(curve: Curves.easeOutCubic)));
    Animation<double> scaleAnimation = controller
        .drive(scaleTween.chain(CurveTween(curve: Curves.easeOutCubic)));

    details = CardAnimationDetails(
        scaleTween: scaleTween,
        translateTween: translateTween,
        scaleAnimation: scaleAnimation,
        translateAnimation: translateAnimation);
  }

  inverseAnimationDetails(
      Offset? positionOfCurrentlyViewingCard, bool shouldReboundCurve) {
    Tween<double> scaleTween =
        Tween(begin: details!.scaleTween.end, end: details!.scaleTween.begin);
    Tween<Offset> translateTween = Tween(
        begin: details!.translateTween.end,
        end: positionOfCurrentlyViewingCard ?? details!.translateTween.begin);

    Animation<Offset> translateAnimation = controller.drive(
        translateTween.chain(CurveTween(
            curve: shouldReboundCurve
                ? Curves.easeOutBack
                : Curves.easeOutCubic)));
    Animation<double> scaleAnimation = controller.drive(scaleTween.chain(
        CurveTween(
            curve: shouldReboundCurve
                ? Curves.easeOutBack
                : Curves.easeOutCubic)));

    details = CardAnimationDetails(
        scaleTween: scaleTween,
        translateTween: translateTween,
        scaleAnimation: scaleAnimation,
        translateAnimation: translateAnimation);
  }

  runEnterAnimation() {
    controller.forward().whenComplete(() {
      controller.reset();
    });
  }

  runExitAnimation(Offset positionOfCurrentlyViewingCard) {
    inverseAnimationDetails(positionOfCurrentlyViewingCard, false);
    controller.forward().whenComplete(() {
      inverseAnimationDetails(null, false);
      controller.reset();
    });
  }
}
