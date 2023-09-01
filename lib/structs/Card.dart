// Everything the app needs to know about a card.
class PokemonCard {
  int? id;
  // Numerical. Ex sm12-12. Set name hyphen set num.
  String code;
  int count;

  PokemonCard({this.id, required this.code, required this.count});
}
