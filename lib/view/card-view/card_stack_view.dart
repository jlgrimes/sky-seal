import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_seal/util/deck.dart';
import 'package:sky_seal/view/card-view/constants.dart';
import 'package:sky_seal/view/primatives/card_view.dart';
import 'package:sky_seal/view/primatives/constants.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';

class CardStackView extends StatelessWidget {
  late String startingCode;
  late int codeIdx;

  CardStackView(this.startingCode);

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);
    codeIdx =
        appState.deck.cards.indexWhere((card) => card.code == startingCode);

    return Container(
      child: Column(children: [
        (Expanded(
            child: Column(
          children: [
            Flexible(
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: desiredFinalWidth,
                          child: CardView(appState.deck.cards[index].code),
                        )
                      ]);
                },
                itemCount: appState.deck.cards.length,
                control: SwiperControl(),
                index: codeIdx,
                onIndexChanged: ((value) {
                  appState.sneakilySetCurrentlyViewingCard(
                      appState.deck.cards[value].code);
                  codeIdx = value;
                }),
                loop: false,
              ),
              // child: Swiper(
              //     layout: SwiperLayout.CUSTOM,
              //     customLayoutOption: CustomLayoutOption(
              //         startIndex: startingCodeIdx - 1, stateCount: 3)
              //       ..addTranslate([
              //         Offset(-370.0, 0.0),
              //         Offset(0.0, 0.0),
              //         Offset(370.0, 0.0)
              //       ])
              //       ..addScale([0.9, 1.0, 0.9], Alignment.center),
              //     itemWidth: 400.0 * cardAspectRatio,
              //     itemHeight: 500.0,
              //     itemCount: cards.length,
              //     itemBuilder: (context, index) {
              //       return CardView(cards[index]);
              //     },
              //     loop: false,
              // onIndexChanged: ((value) {
              //   appState.setCurrentlyViewingCard(cards[value]);
              // })),
            )
          ],
        )))
      ]),
    );
  }
}
