import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';
import '../primatives/card_with_action_view.dart';
import 'dart:ui';

class CardStackView extends StatelessWidget {
  void Function() openContainerAction;
  late List<CardWithActionView> cards;

  CardStackView(Function() this.openContainerAction, {super.key}) {
    cards = [
      CardWithActionView(openContainerAction),
      CardWithActionView(openContainerAction),
      CardWithActionView(openContainerAction),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
                    ]),
              itemWidth: 300.0,
              itemHeight: 400.0,
              itemCount: 3,
              itemBuilder: (context, index) {
                return CardWithActionView(openContainerAction);
              },
              loop: false,
            ),
          )
        ],
      )))
    ]);
  }
}
