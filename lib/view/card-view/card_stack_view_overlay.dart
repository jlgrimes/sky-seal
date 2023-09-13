import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:concealed/structs/Card.dart';
import 'package:concealed/view/card-view/card_animator.dart';
import 'package:concealed/view/card-view/constants.dart';
import 'package:concealed/view/card-view/whoop_card_view_overlay.dart';
import 'package:concealed/view/primatives/card_view.dart';
import 'package:concealed/view/state/app_state_provider.dart';

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

class _CardStackViewOverlayState extends State<CardStackViewOverlay>
    with AfterLayoutMixin<CardStackViewOverlay> {
  DeckViewState _deckViewState = DeckViewState.exitingCardFocus;
  final SwiperController _swiperController = SwiperController();
  int _tempIndex = 0;

  @override
  void initState() {
    super.initState(); //when this route starts, it will execute this code
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

  @override
  void afterFirstLayout(BuildContext context) {
    AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);
    setState(() {
      _tempIndex = appState.deck.cards
          .indexWhere((card) => card.code == widget.card.code);
    });
  }

  exitCardFocus(AppStateProvider appState, Function? onCardDismissed) {
    setState(() {
      //tells the widget builder to rebuild again because ui has updated
      _deckViewState = DeckViewState
          .exitingCardFocus; //update the variable declare this under your class so its accessible for both your widget build and initState which is located under widget build{}
    });
    // appState
    //     .setDeckViewState(DeckViewState.exitingCardFocus);
    //widget.cardAnimator.controller.reverse();
    widget.cardAnimator.runExitAnimation(appState.cardPositionState
        .getCardPosition(appState.currentlyViewingCard ?? widget.card.code));
    Future.delayed(Duration(milliseconds: 200), () {
      Navigator.pop(context);
      // appState
      //     .setDeckViewState(DeckViewState.noCardsFocused);
    });

    Future.delayed(Duration(milliseconds: 600), () {
      onCardDismissed == null ? () => {} : onCardDismissed();
      // appState
      //     .setDeckViewState(DeckViewState.noCardsFocused);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    Size size = MediaQuery.of(context).size;

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
                        exitCardFocus(appState, null);
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
                                    index: _tempIndex,
                                    onIndexChanged: ((value) {
                                      setState(() {
                                        _tempIndex = value;
                                      });
                                      appState.sneakilySetCurrentlyViewingCard(
                                          appState.deck.cards[value].code);
                                    }),
                                    controller: _swiperController,
                                    duration: 200,
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
                                          onPressed: _tempIndex == 0
                                              ? null
                                              : () =>
                                                  _swiperController.previous(),
                                          icon: const Icon(
                                              Icons.chevron_left_rounded),
                                          iconSize: 40.0,
                                        ),
                                        IconButton.filledTonal(
                                          onPressed: _tempIndex ==
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
                                        IconButton.outlined(
                                          onPressed: () => {
                                            if (appState.deck.cards[_tempIndex]
                                                    .count ==
                                                1)
                                              {
                                                exitCardFocus(appState, () {
                                                  appState.removeCardFromDeck(
                                                      appState
                                                          .deck
                                                          .cards[_tempIndex]
                                                          .code);
                                                  appState.cardPositionState
                                                      .recalculatePositions(
                                                          appState.deck.cards
                                                              .map(
                                                                  (e) => e.code)
                                                              .toList());
                                                })
                                              },
                                            appState.updateCardCount(
                                                _tempIndex,
                                                appState.deck.cards[_tempIndex]
                                                        .count -
                                                    1)
                                          },
                                          icon: const Icon(Icons.remove),
                                        ),
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Text(
                                          appState.deck.cards[_tempIndex].count
                                              .toString(),
                                          textScaleFactor: 3.5,
                                        ),
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        IconButton.outlined(
                                          onPressed: () =>
                                              appState.updateCardCount(
                                                  _tempIndex,
                                                  appState
                                                          .deck
                                                          .cards[_tempIndex]
                                                          .count +
                                                      1),
                                          icon: const Icon(Icons.add),
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
