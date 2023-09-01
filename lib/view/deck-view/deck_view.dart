import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:indexed/indexed.dart';
import 'package:provider/provider.dart';
import 'package:sky_seal/view/card-view/focused_card_container.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';

class DeckView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);

    return Indexer(
      children: [
        StaggeredGrid.count(crossAxisCount: 3, children: [
          ...appState.deck.cards.map((card) => FocusedCardContainer(
                card: card,
              ))
        ])
      ],
    );
  }
}
