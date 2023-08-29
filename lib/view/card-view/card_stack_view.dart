import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:sky_seal/view/primatives/card_view.dart';
import 'package:sky_seal/view/primatives/constants.dart';
import 'dart:ui';

class CardStackView extends StatelessWidget {
  void Function() openContainerAction;
  late List<String> cards;

  CardStackView(Function() this.openContainerAction, {super.key}) {
    cards = ['swsh12-139', 'swsh12-140', 'swsh12-141'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        (Expanded(
            child: Column(
          children: [
            // ClipRect(
            //   child: BackdropFilter(
            //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            //     child: Container(
            //       width: 200.0,
            //       height: 200.0,
            //       decoration:
            //           BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
            //       child: Center(
            //         child: Text('Frosted',
            //             style: Theme.of(context).textTheme.displayLarge),
            //       ),
            //     ),
            //   ),
            // ),
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
                itemWidth: 500.0 * cardAspectRatio,
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
