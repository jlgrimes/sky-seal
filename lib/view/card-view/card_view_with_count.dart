import 'package:flutter/material.dart';
import 'package:concealed/structs/Card.dart';
import 'package:concealed/view/primatives/card_view.dart';

class CardViewWithCount extends StatelessWidget {
  PokemonCard pokemonCard;

  CardViewWithCount({required this.pokemonCard});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      CardView(pokemonCard.code),
      Card(
          elevation: 1,
          child: SizedBox(
              height: 30,
              width: 30,
              child: Center(child: Text(pokemonCard.count.toString()))))
    ]);
  }
}
