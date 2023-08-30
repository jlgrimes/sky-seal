import 'package:flutter/material.dart';

class DeckViewProvider extends ChangeNotifier {
  String? currentlyViewingCard;

  setCurrentlyViewingCard(String? code) {
    currentlyViewingCard = code;
    notifyListeners();
  }
}
