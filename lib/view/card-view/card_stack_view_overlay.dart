import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_seal/structs/Card.dart';
import 'package:sky_seal/view/card-view/card_animator.dart';
import 'package:sky_seal/view/card-view/constants.dart';
import 'package:sky_seal/view/card-view/whoop_card_view_overlay.dart';
import 'package:sky_seal/view/primatives/card_view.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';

class CardStackViewOverlay extends StatefulWidget {
  final PokemonCard card;
  final Offset childOffset;
  final Size childSize;
  final Widget child;
  final CardAnimator cardAnimator;

  CardStackViewOverlay(
      {Key? key,
      required this.card,
      required this.childOffset,
      required this.childSize,
      required this.child,
      required this.cardAnimator})
      : super(key: key);

  @override
  State<CardStackViewOverlay> createState() => _CardStackViewOverlayState();
}

class _CardStackViewOverlayState extends State<CardStackViewOverlay> {
  DeckViewState _deckViewState = DeckViewState.exitingCardFocus;
  final SwiperController _swiperController = SwiperController();
  int? _codeIdx;
  late int _tempCount;

  @override
  void initState() {
    super.initState(); //when this route starts, it will execute this code
    _tempCount = widget.card.count;

    Future.delayed(const Duration(milliseconds: 300), () {
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

  addOneCopy() {
    setState(() {
      _tempCount += 1;
    });
  }

  subtractOneCopy() {
    setState(() {
      _tempCount -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    Size size = MediaQuery.of(context).size;

    int codeIdx = _codeIdx ??
        appState.deck.cards.indexWhere((card) => card.code == widget.card.code);

    return Scaffold(
      backgroundColor: Colors.transparent,
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(children: [
      //     IconButton(
      //         onPressed: (() => setState(() {
      //               _tempCount += 1;
      //             })),
      //         icon: const Icon(Icons.add))
      //   ]),
      // ),
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
                  cardAnimator: widget.cardAnimator,
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
                        //widget.cardAnimator.controller.reverse();
                        widget.cardAnimator.runExitAnimation(appState
                            .cardPositionState
                            .getCardPosition(appState.currentlyViewingCard ??
                                widget.card.code));
                        Future.delayed(Duration(milliseconds: 200), () {
                          Navigator.pop(context);
                          // appState
                          //     .setDeckViewState(DeckViewState.noCardsFocused);
                        });
                      },
                      child: Container(
                        child: Column(children: [
                          (Expanded(
                              child: Column(
                            children: [
                              Flexible(
                                  child: Stack(
                                children: [
                                  Swiper(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: desiredFinalWidth,
                                              child: CardView(appState
                                                  .deck.cards[index].code),
                                            )
                                          ]);
                                    },
                                    itemCount: appState.deck.cards.length,
                                    index: codeIdx,
                                    onIndexChanged: ((value) {
                                      appState.sneakilySetCurrentlyViewingCard(
                                          appState.deck.cards[value].code);
                                      setState(() {
                                        _codeIdx = value;
                                      });
                                    }),
                                    controller: _swiperController,
                                    loop: false,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton.filledTonal(
                                          onPressed: codeIdx == 0
                                              ? null
                                              : () =>
                                                  _swiperController.previous(),
                                          icon: const Icon(
                                              Icons.chevron_left_rounded),
                                          iconSize: 40.0,
                                        ),
                                        IconButton.filledTonal(
                                          onPressed: codeIdx ==
                                                  appState.deck.cards.length - 1
                                              ? null
                                              : () => _swiperController.next(),
                                          icon: const Icon(
                                              Icons.chevron_right_rounded),
                                          iconSize: 40.0,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(64.0),
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton.filled(
                                          onPressed: () => subtractOneCopy(),
                                          icon: const Icon(Icons.remove),
                                          iconSize: 32.0,
                                        ),
                                        FilledButton.tonal(
                                          onPressed: () => {},
                                          style: FilledButton.styleFrom(
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(30.0)),
                                          child: Text(
                                            _tempCount.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textScaleFactor: 4,
                                          ),
                                        ),
                                        IconButton.filled(
                                          onPressed: () => addOneCopy(),
                                          icon: const Icon(Icons.add),
                                          iconSize: 32.0,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          )))
                        ]),
                      ))),
            )
          ],
        ),
      ),
    );
  }
}
