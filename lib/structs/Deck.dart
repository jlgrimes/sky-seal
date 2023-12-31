// Proves everything you need to open and run a deck.
import 'package:concealed/structs/Card.dart';
import 'package:concealed/view/deck-list-view/DeckPermissions.dart';

class Deck {
  String? id;
  String? name;
  DeckPermissions? permissions;
  List<PokemonCard> cards;

  Deck({required this.cards, this.id, this.name, this.permissions});

  addCard(card) {
    cards.add(card);
  }

  removeCard(String code) {
    cards.removeWhere((element) => element.code == code);
  }
}
