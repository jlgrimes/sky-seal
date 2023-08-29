import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';
import '../primatives/card_with_action_view.dart';
import 'dart:ui';

class CardStackView extends StatelessWidget {
  void Function() openContainerAction;
  late List<CardWithActionView> cards;

  CardStackView(Function() this.openContainerAction, {super.key}) {
    this.cards = [
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
            child: CardSwiper(
              cardsCount: cards.length,
              cardBuilder:
                  (context, index, percentThresholdX, percentThresholdY) =>
                      cards[index],
              allowedSwipeDirection:
                  AllowedSwipeDirection.only(left: true, right: true),
              maxAngle: 0,
            ),
          )
        ],
      )))
    ]);
  }
}
