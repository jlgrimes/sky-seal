// Proves everything you need to open and run a deck.
import 'package:sky_seal/structs/Card.dart';

class Deck {
  String? id;
  List<PokemonCard> cards;

  Deck({required this.cards, this.id});

  addCard(String code) {
    cards.add(PokemonCard(code: code, count: 1));
  }
}
