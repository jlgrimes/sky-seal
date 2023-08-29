import 'package:flutter/material.dart';
import 'package:sky_seal/deck-view/card_in_deck_view.dart';
import 'package:sky_seal/primatives/card_view.dart';

class DeckView extends StatelessWidget {
  void Function() openContainerAction;

  DeckView(Function() this.openContainerAction, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      padding: const EdgeInsets.all(16.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [CardInDeckView(openContainerAction)],
    ));
  }
}
