import 'package:flutter/material.dart';

class CardPosition {
  String code;
  Offset offset;

  CardPosition({required this.code, required this.offset});
}

class CardPositioningState {
  // Key is the card code
  Map<String, CardPosition> positions = {};

  addCardPosition(String code, Offset offset) {
    positions[code] = CardPosition(code: code, offset: offset);
  }
}
