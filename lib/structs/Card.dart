// Everything the app needs to know about a card.
import 'package:flutter/material.dart';
import 'package:concealed/util/sets.dart';

class PokemonCard {
  int? id;
  // Numerical. Ex sm12-12. Set name hyphen set num.
  String code;
  String? supertype;
  String? rarity;
  int count;
  late Image image;

  PokemonCard(
      {this.id,
      required this.code,
      required this.supertype,
      required this.rarity,
      required this.count}) {
    image = Image.network(convertSetCodeToImageUrl(code));
  }

  preloadImage(BuildContext context) async {
    await precacheImage(image.image, context);
  }
}
