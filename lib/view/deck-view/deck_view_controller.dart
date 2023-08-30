import 'package:flutter/material.dart';
import 'package:sky_seal/view/deck-view/deck_view.dart';
import 'package:sky_seal/view/deck-view/deck_view_store_provider.dart';

class DeckViewController extends StatefulWidget {
  @override
  State<DeckViewController> createState() => _ViewControllerState();
}

class _ViewControllerState extends State<DeckViewController> {
  String? _currentlyViewingCard;

  void initState() {
    super.initState();

    _currentlyViewingCard = null;
  }

  setCurrentlyViewingCard(String? code) {
    setState(() {
      _currentlyViewingCard = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DeckViewStoreProvider(
        currentlyViewingCard: _currentlyViewingCard,
        child: DeckView(setCurrentlyViewingCard));
  }
}
