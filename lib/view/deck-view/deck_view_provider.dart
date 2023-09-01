import 'package:flutter/material.dart';
import 'package:sky_seal/structs/Card.dart';
import 'package:sky_seal/structs/Deck.dart';

class DeckViewProvider extends ChangeNotifier {
  String? currentlyViewingCard;
  Deck deck = Deck(cards: []);

  setCurrentlyViewingCard(String? code) {
    currentlyViewingCard = code;
    notifyListeners();
  }
}
