import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  String? currentlyViewingCard;

  setCurrentlyViewingCard(String? code) {
    currentlyViewingCard = code;
    notifyListeners();
  }
}
