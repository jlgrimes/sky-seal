import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sky_seal/view/card-view/card_stack_view_overlay.dart';
import 'package:sky_seal/view/primatives/constants.dart';

class FocusedCardContainer extends StatefulWidget {
  final Widget child, menuContent;

  const FocusedCardContainer(
      {Key? key, required this.child, required this.menuContent});

  @override
  _FocusedMenuHolderState createState() => _FocusedMenuHolderState();
}

class _FocusedMenuHolderState extends State<FocusedCardContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Tween<double> scaleTween; // <<< Tween for first animation
  late Tween<Offset> translateTween; // <<< Tween for first animation
  late Animation<double> scaleAnimation; // <<< second animation
  late Animation<Offset> translateAnimation; // <<< second animation

  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  Size? childSize;

  void initState() {
    super.initState();

    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
  }

  getOffsetAndDeclareAnimations(BuildContext context) {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject()! as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });

    double scale = 1.3;

    scaleTween = Tween(begin: 1, end: scale);
    Size windowSize = MediaQuery.of(context).size;

    double initialArea = size.height * size.width;
    double finalArea = initialArea * scale;
    double finalHeight = sqrt(finalArea / cardAspectRatio);
    double finalWidth = finalHeight * cardAspectRatio;

    final double xTranslate =
        (windowSize.width / 2) - finalWidth / 2 - (finalWidth - size.width);
    final double yTranslate =
        (windowSize.height / 2) - finalHeight / 2 - (finalHeight - size.height);

    Offset startingOffset = Offset(offset.dx, offset.dy);
    Offset finalOffset = Offset(xTranslate, yTranslate);
    translateTween = Tween(begin: startingOffset, end: finalOffset);

    translateAnimation = controller.drive(translateTween);
    scaleAnimation = controller.drive(scaleTween);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          getOffsetAndDeclareAnimations(context);
          await Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 100),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    animation = Tween(begin: 0.0, end: 1.0).animate(animation);
                    return FadeTransition(
                        opacity: animation,
                        child: CardStackViewOverlay(
                          menuContent: widget.menuContent,
                          child: widget.child,
                          childOffset: childOffset,
                          childSize: childSize!,
                          controller: controller,
                          scaleAnimation: scaleAnimation,
                          translateAnimation: translateAnimation,
                        ));
                  },
                  fullscreenDialog: true,
                  opaque: false));
          controller.forward();
        },
        child: widget.child);
  }
}
