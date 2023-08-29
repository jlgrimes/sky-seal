import 'package:flutter/material.dart';
import 'package:sky_seal/view/deck-view/card_in_deck_view.dart';

class DeckView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [CardInDeckview('swsh12-139')]);

    return Column(
      children: [
        GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.716),
          padding: const EdgeInsets.all(16.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            CardInDeckview('swsh12-139'),
            CardInDeckview('swsh12-139'),
            CardInDeckview('swsh12-139'),
            CardInDeckview('swsh12-139'),
            CardInDeckview('swsh12-139'),
            CardInDeckview('swsh12-139'),
          ],
        )
      ],
    );
  }
}
