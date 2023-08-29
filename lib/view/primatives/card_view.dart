import 'package:flutter/material.dart';
import 'package:sky_seal/util/sets.dart';

class CardView extends StatelessWidget {
  String code;
  String imageUrl;

  CardView(this.code) : imageUrl = convertSetCodeToImageUrl(code);

  @override
  Widget build(BuildContext context) {
    return Image.network(imageUrl);
  }
}
