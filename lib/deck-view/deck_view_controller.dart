import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:sky_seal/card-view/card_stack_view.dart';
import 'package:sky_seal/deck-view/deck_view.dart';

class DeckViewController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        closedBuilder: (context, action) {
          return DeckView(action);
        },
        openBuilder: (context, action) {
          return CardStackView(action);
        });
  }
}
