import 'package:flutter/material.dart';
import 'package:sky_seal/view/card-view/card_stack_view.dart';
import 'package:sky_seal/view/card-view/focused_card_container.dart';
import 'package:sky_seal/view/primatives/card_view.dart';

class CardInDeckview extends StatelessWidget {
  String code;

  CardInDeckview(this.code, {super.key});

  @override
  Widget build(BuildContext context) {
    return FocusedCardContainer(
        child: CardView(code), menuContent: CardStackView(code));
  }
}
