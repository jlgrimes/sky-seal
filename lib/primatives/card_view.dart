import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String imageUrl = 'https://images.pokemontcg.io/swsh12/139_hires.png';

    return Container(child: Image.network(imageUrl));
  }
}
