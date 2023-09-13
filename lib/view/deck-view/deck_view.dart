import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:indexed/indexed.dart';
import 'package:provider/provider.dart';
import 'package:concealed/view/card-view/focused_card_container.dart';
import 'package:concealed/view/primatives/constants.dart';
import 'package:concealed/view/state/app_state_provider.dart';

class DeckView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);

    return Expanded(
        child: GridView.count(
            crossAxisCount: 3,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            childAspectRatio: cardAspectRatio,
            mainAxisSpacing: 6.0,
            crossAxisSpacing: 6.0,
            padding: const EdgeInsets.all(6.0),
            children: [
          ...appState.deck.cards.map((card) => FocusedCardContainer(
                card: card,
              ))
        ]));
  }
}
