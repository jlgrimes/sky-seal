import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';

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
  bool _shouldRenderStack = false;

  @override
  void initState() {
    super.initState(); //when this route starts, it will execute this code
    Future.delayed(const Duration(milliseconds: 400), () {
      //asynchronous delay
      if (this.mounted) {
        //checks if widget is still active and not disposed
        setState(() {
          //tells the widget builder to rebuild again because ui has updated
          _shouldRenderStack =
              true; //update the variable declare this under your class so its accessible for both your widget build and initState which is located under widget build{}
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.black.withOpacity(0),
                    ),
                  ],
                )),
            Visibility(
              visible: !_shouldRenderStack,
              child: Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedBuilder(
                    animation: widget.controller,
                    builder: ((context, _) {
                      return Transform.translate(
                          offset: Offset(widget.translateAnimation.value.dx,
                              widget.translateAnimation.value.dy),
                          child: SizedBox(
                              width: widget.childSize.width,
                              height: widget.childSize.height,
                              child: Transform.scale(
                                  scale: widget.scaleAnimation.value,
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                      child: widget.child))));
                    }),
                  )),
            ),
            Visibility(
              visible: _shouldRenderStack,
              child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          //tells the widget builder to rebuild again because ui has updated
                          _shouldRenderStack =
                              false; //update the variable declare this under your class so its accessible for both your widget build and initState which is located under widget build{}
                        });
                        // appState.setCurrentlyViewingCard(null);
                        widget.controller.reverse();
                        Future.delayed(Duration(milliseconds: 300), () {
                          Navigator.pop(context);
                        });
                      },
                      child: widget.menuContent)),
            )
          ],
        ),
      ),
    );
  }
}
