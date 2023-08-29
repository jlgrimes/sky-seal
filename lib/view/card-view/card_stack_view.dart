import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:sky_seal/util/deck.dart';
import 'package:sky_seal/view/primatives/card_view.dart';
import 'package:sky_seal/view/primatives/constants.dart';

class CardStackView extends StatelessWidget {
  late Function(String code) setCurrentlyViewingCard;
  late String startingCode;
  List<String> cards = myDeckList;

  CardStackView(this.startingCode, this.setCurrentlyViewingCard) {
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
                  onIndexChanged: ((value) {})),
            )
          ],
        )))
      ]),
    );
  }
}
