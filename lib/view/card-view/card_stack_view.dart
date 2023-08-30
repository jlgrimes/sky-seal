import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_seal/util/deck.dart';
import 'package:sky_seal/view/primatives/card_view.dart';
import 'package:sky_seal/view/primatives/constants.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';

class CardStackView extends StatelessWidget {
  late String startingCode;
  List<String> cards = myDeckList;

  CardStackView(this.startingCode) {
    // This should not happen help
    if (!cards.contains(startingCode)) return;
    int startingCodeIdx = cards.indexOf(startingCode);

    cards = [
      ...cards.sublist(startingCodeIdx),
      ...cards.sublist(0, startingCodeIdx)
    ];
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);

    return Container(
      child: Column(children: [
        (Expanded(
            child: Column(
          children: [
            Flexible(
              child: Swiper(
                  layout: SwiperLayout.CUSTOM,
                  customLayoutOption:
                      CustomLayoutOption(startIndex: -1, stateCount: 3)
                        ..addTranslate([
                          Offset(-370.0, 0.0),
                          Offset(0.0, 0.0),
                          Offset(370.0, 0.0)
                        ])
                        ..addScale([0.9, 1.0, 0.9], Alignment.center),
                  itemWidth: 400.0 * cardAspectRatio,
                  itemHeight: 500.0,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return CardView(cards[index]);
                  },
                  loop: false,
                  onIndexChanged: ((value) {
                    appState.setCurrentlyViewingCard(cards[value]);
                  })),
            )
          ],
        )))
      ]),
    );
  }
}
