import 'dart:ui';

import 'package:flutter/material.dart';

class CardStackViewOverlay extends StatelessWidget {
  final Offset childOffset;
  final Size childSize;
  final Widget menuContent;
  final Widget child;

  const CardStackViewOverlay({
    Key? key,
    required this.menuContent,
    required this.childOffset,
    required this.childSize,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final double scaleValue = 2.5;
    final double xTranslate =
        (size.width / 2) - childOffset.dx - childSize.width / 2;
    final double yTranslate =
        (size.height / 2) - childOffset.dy - childSize.height / 2;

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
              top: childOffset.dy,
              left: childOffset.dx,
              child: TweenAnimationBuilder(
                curve: Curves.easeOutBack,
                duration: Duration(milliseconds: 200),
                builder: (BuildContext context, value, Widget? child) {
                  return Transform.translate(
                    offset: Offset(xTranslate, yTranslate),
                    child: Transform.scale(
                        scale: value * scaleValue,
                        alignment: Alignment.center,
                        child: child),
                  );

                  return Transform.scale(
                    scale: value * scaleValue,
                    alignment: Alignment.center,
                    child: Transform.translate(
                        offset: Offset(xTranslate, yTranslate), child: child),
                  );
                },
                tween: Tween(begin: 0.0, end: 1.0),
                child: Container(
                  width: childSize.width,
                  height: childSize.height,
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
                    child: menuContent,
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
