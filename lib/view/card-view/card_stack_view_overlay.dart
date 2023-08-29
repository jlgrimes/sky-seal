import 'dart:ui';

import 'package:flutter/material.dart';

class CardStackViewOverlay extends StatefulWidget {
  final Offset childOffset;
  final Size childSize;
  final Widget menuContent;
  final Widget child;
  final AnimationController controller;
  final Animation<double> scaleAnimation;
  final Animation<Offset> translateAnimation;

  CardStackViewOverlay(
      {Key? key,
      required this.menuContent,
      required this.childOffset,
      required this.childSize,
      required this.child,
      required this.controller,
      required this.scaleAnimation,
      required this.translateAnimation})
      : super(key: key);

  @override
  State<CardStackViewOverlay> createState() => _CardStackViewOverlayState();
}

class _CardStackViewOverlayState extends State<CardStackViewOverlay> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final double scaleValue = 2.5;
    final double xTranslate =
        (size.width / 2) - widget.childOffset.dx - widget.childSize.width / 2;
    final double yTranslate =
        (size.height / 2) - widget.childOffset.dy - widget.childSize.height / 2;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  widget.controller.reverse();
                  Future.delayed(Duration(milliseconds: 300), () {
                    Navigator.pop(context);
                  });
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                )),
            Positioned(
                top: 0,
                left: 0,
                child: AnimatedBuilder(
                  animation: widget.controller,
                  builder: ((context, _) {
                    return Transform.translate(
                        offset: Offset(widget.translateAnimation.value.dx,
                            widget.translateAnimation.value.dy),
                        child: Container(
                            width: widget.childSize.width,
                            height: widget.childSize.height,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                                boxShadow: [
                                  const BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 10,
                                      spreadRadius: 1)
                                ]),
                            child: Transform.scale(
                                scale: widget.scaleAnimation.value,
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    child: widget.menuContent))));
                  }),
                )
                //   child: TweenAnimationBuilder(
                //     curve: Curves.easeOutBack,
                //     duration: const Duration(milliseconds: 200),
                //     builder: (BuildContext context, value, Widget? child) {
                // return Transform.translate(
                //   offset: Offset(xTranslate, yTranslate),
                //   child: Transform.scale(
                //       scale: value * scaleValue,
                //       alignment: Alignment.center,
                //       child: child),
                // );
                //     },
                //     tween: Tween(begin: 0.0, end: 1.0),
                // child: Container(
                //   width: widget.childSize.width,
                //   height: widget.childSize.height,
                //   decoration: BoxDecoration(
                //       color: Colors.grey.shade200,
                //       borderRadius:
                //           const BorderRadius.all(Radius.circular(5.0)),
                //       boxShadow: [
                //         const BoxShadow(
                //             color: Colors.black38,
                //             blurRadius: 10,
                //             spreadRadius: 1)
                //       ]),
                //   child: ClipRRect(
                //     borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                //     child: widget.menuContent,
                //   ),
                // ),
                //   ),
                ),
          ],
        ),
      ),
    );
  }
}
