import 'package:flutter/material.dart';
import 'package:sky_seal/util/sets.dart';
import 'package:sky_seal/view/deck-view/deck_view_store_provider.dart';
import 'package:sky_seal/view/primatives/card_view.dart';

class WhoopCardView extends CardView {
  WhoopCardView(code) : super(code);

  @override
  Widget build(BuildContext context) {
    final currentlyViewingCard =
        DeckViewStoreProvider.of(context)?.currentlyViewingCard;

    return CardView(currentlyViewingCard ?? code);
  }
}
