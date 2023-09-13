import 'package:flutter/material.dart';
import 'package:concealed/util/sets.dart';

class CardView extends StatelessWidget {
  String code;
  String imageUrl;

  CardView(this.code) : imageUrl = convertSetCodeToImageUrl(code);

  @override
  Widget build(BuildContext context) {
    return Image.network(imageUrl);
  }
}
