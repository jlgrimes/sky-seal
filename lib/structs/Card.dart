// Everything the app needs to know about a card.
class Card {
  // Numerical. Ex sm12
  String setCode;
  int setNumber;
  int count;

  Card({required this.setCode, required this.setNumber, required this.count});

  getCode() {
    return '$setCode-$setNumber';
  }
}
