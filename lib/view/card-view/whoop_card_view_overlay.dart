import 'package:flutter/material.dart';
import 'package:concealed/view/card-view/card_animator.dart';

class WhoopCardViewOverlay extends StatelessWidget {
  final Widget child;
  final CardAnimator cardAnimator;
  final Size childSize;

  WhoopCardViewOverlay(
      {Key? key,
      required this.child,
      required this.cardAnimator,
      required this.childSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        left: 0,
        child: AnimatedBuilder(
          animation: cardAnimator.controller,
          builder: ((context, _) {
            if (cardAnimator.details == null) {
              return child;
            }

            return Transform.translate(
                offset: Offset(
                    cardAnimator.details!.translateAnimation.value.dx,
                    cardAnimator.details!.translateAnimation.value.dy),
                child: SizedBox(
                    width: childSize.width,
                    height: childSize.height,
                    child: Transform.scale(
                        scale: cardAnimator.details!.scaleAnimation.value,
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                            child: child))));
          }),
        ));
  }
}
