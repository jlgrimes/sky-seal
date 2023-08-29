import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';
import '../primatives/card_with_action_view.dart';

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
    return (Expanded(
        child: Column(
      children: [
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
    )));
  }
}
