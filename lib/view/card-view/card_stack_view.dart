import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:sky_seal/view/primatives/card_view.dart';
import 'package:sky_seal/view/primatives/constants.dart';

class CardStackView extends StatelessWidget {
  late List<String> cards;

  CardStackView({super.key}) {
    cards = ['swsh12-139', 'swsh12-140', 'swsh12-141'];
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
              ),
            )
          ],
        )))
      ]),
    );
  }
}
