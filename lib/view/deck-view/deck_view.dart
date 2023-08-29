import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:indexed/indexed.dart';
import 'package:sky_seal/util/deck.dart';
import 'package:sky_seal/view/deck-view/card_in_deck_view.dart';

class DeckView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Indexer(
      children: [
        StaggeredGrid.count(
            crossAxisCount: 3,
            children: [...myDeckList.map((code) => CardInDeckview(code))])
      ],
    );
  }
}
