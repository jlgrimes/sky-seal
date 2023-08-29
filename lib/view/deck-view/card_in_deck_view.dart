import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:sky_seal/view/card-view/card_stack_view.dart';
import 'package:sky_seal/view/primatives/card_with_action_view.dart';

class CardInDeckview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OpenContainer(closedBuilder: (context, action) {
      return CardWithActionView(action);
    }, openBuilder: (context, action) {
      return CardStackView(action);
    });
  }
}
