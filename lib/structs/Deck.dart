// Proves everything you need to open and run a deck.
import 'package:sky_seal/structs/Card.dart';

class Deck {
  String? id;
  String? name;
  List<PokemonCard> cards;

  Deck({required this.cards, this.id, this.name});

  addCard(card) {
    cards.add(card);
  }

  removeCard(String code) {
    cards.removeWhere((element) => element.code == code);
  }
}
