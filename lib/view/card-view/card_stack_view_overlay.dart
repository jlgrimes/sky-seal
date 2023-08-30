import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_seal/view/card-view/card_animator.dart';
import 'package:sky_seal/view/card-view/whoop_card_view_overlay.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';

class CardStackViewOverlay extends StatefulWidget {
  final Offset childOffset;
  final Size childSize;
  final Widget menuContent;
  final Widget child;
  final CardAnimator focusOnCardAnimator;
  final CardAnimator cardGoAwayAnimator;

  CardStackViewOverlay(
      {Key? key,
      required this.menuContent,
      required this.childOffset,
      required this.childSize,
      required this.child,
      required this.focusOnCardAnimator,
      required this.cardGoAwayAnimator})
      : super(key: key);

  @override
  State<CardStackViewOverlay> createState() => _CardStackViewOverlayState();
}

class _CardStackViewOverlayState extends State<CardStackViewOverlay> {
  DeckViewState _deckViewState = DeckViewState.exitingCardFocus;

  @override
  void initState() {
    super.initState(); //when this route starts, it will execute this code
    Future.delayed(const Duration(milliseconds: 400), () {
      //asynchronous delay
      if (this.mounted) {
        //checks if widget is still active and not disposed
        setState(() {
          //tells the widget builder to rebuild again because ui has updated
          _deckViewState = DeckViewState
              .enteringCardFocus; //update the variable declare this under your class so its accessible for both your widget build and initState which is located under widget build{}
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);

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
                visible: _deckViewState == DeckViewState.exitingCardFocus,
                child: WhoopCardViewOverlay(
                  child: widget.child,
                  cardAnimator: widget.focusOnCardAnimator,
                  childSize: widget.childSize,
                )),
            Visibility(
              visible: _deckViewState == DeckViewState.enteringCardFocus,
              child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          //tells the widget builder to rebuild again because ui has updated
                          _deckViewState = DeckViewState
                              .exitingCardFocus; //update the variable declare this under your class so its accessible for both your widget build and initState which is located under widget build{}
                        });
                        // appState
                        //     .setDeckViewState(DeckViewState.exitingCardFocus);
                        widget.focusOnCardAnimator.controller.reverse();
                        Future.delayed(Duration(milliseconds: 300), () {
                          Navigator.pop(context);
                          // appState
                          //     .setDeckViewState(DeckViewState.noCardsFocused);
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
