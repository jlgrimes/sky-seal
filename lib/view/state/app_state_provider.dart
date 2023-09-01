import 'package:flutter/material.dart';
import 'package:sky_seal/structs/Card.dart';
import 'package:sky_seal/structs/Deck.dart';
import 'package:sky_seal/view/state/card_positioning_state.dart';

enum DeckViewState {
  noCardsFocused,
  enteringCardFocus,
  focusedOnCard,
  exitingCardFocus
}

class AppStateProvider extends ChangeNotifier {
  String? currentlyViewingCard;
  DeckViewState deckViewState = DeckViewState.noCardsFocused;
  CardPositioningState cardPositionState = CardPositioningState();
  Deck deck = Deck(cards: []);

  sneakilySetCurrentlyViewingCard(String? code) {
    currentlyViewingCard = code;
  }

  setCurrentlyViewingCard(String? code) {
    currentlyViewingCard = code;
    notifyListeners();
  }

  setDeckViewState(DeckViewState newState) {
    debugPrint(newState.toString());
    deckViewState = newState;
    notifyListeners();
  }

  addCardToDeck(String code) {
    deck = Deck(cards: [...deck.cards, PokemonCard(code: code, count: 1)]);
    notifyListeners();
  }
}
