import 'dart:ui';

import 'package:flutter/material.dart';

class CardStackViewOverlay extends StatefulWidget {
  final Offset childOffset;
  final Size childSize;
  final Widget menuContent;
  final Widget child;

  CardStackViewOverlay({
    Key? key,
    required this.menuContent,
    required this.childOffset,
    required this.childSize,
    required this.child,
  }) : super(key: key);

  @override
  State<CardStackViewOverlay> createState() => _CardStackViewOverlayState();
}

class _CardStackViewOverlayState extends State<CardStackViewOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Tween<Alignment> alignmentTween; // <<< Tween for first animation
  late Tween<double> rotateTween; // <<< Tween for second animation
  late Animation<Alignment> alignmentAnimation; // <<< first animation
  late Animation<double> rotateAnimation; // <<< second animation

  void initState() {
    super.initState();

    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    alignmentTween = Tween(
        begin: Alignment.topCenter,
        end: Alignment
            .bottomCenter); // <<< define start and end value of alignment animation
    rotateTween = Tween(
        begin: 0,
        end: 8 * 3.14); // <<< define start and end value of rotation animation
    alignmentAnimation =
        controller.drive(alignmentTween); // <<< create align animation
    rotateAnimation =
        controller.drive(rotateTween); // <<< create rotation animation
  }

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
                  Navigator.pop(context);
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                )),
            Positioned(
              top: widget.childOffset.dy,
              left: widget.childOffset.dx,
              child: TweenAnimationBuilder(
                curve: Curves.easeOutBack,
                duration: const Duration(milliseconds: 200),
                builder: (BuildContext context, value, Widget? child) {
                  return Transform.translate(
                    offset: Offset(xTranslate, yTranslate),
                    child: Transform.scale(
                        scale: value * scaleValue,
                        alignment: Alignment.center,
                        child: child),
                  );
                },
                tween: Tween(begin: 0.0, end: 1.0),
                child: Container(
                  width: widget.childSize.width,
                  height: widget.childSize.height,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        const BoxShadow(
                            color: Colors.black38,
                            blurRadius: 10,
                            spreadRadius: 1)
                      ]),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: widget.menuContent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
