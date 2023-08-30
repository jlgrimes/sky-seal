import 'package:flutter/material.dart';

enum DeckViewState {
  noCardsFocused,
  enteringCardFocus,
  focusedOnCard,
  exitingCardFocus
}

class AppStateProvider extends ChangeNotifier {
  String? currentlyViewingCard;
  DeckViewState deckViewState = DeckViewState.noCardsFocused;

  setCurrentlyViewingCard(String? code) {
    currentlyViewingCard = code;
    notifyListeners();
  }

  setDeckViewState(DeckViewState newState) {
    debugPrint(newState.toString());
    deckViewState = newState;
    notifyListeners();
  }
}
