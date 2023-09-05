import 'package:flutter/material.dart';
import 'package:sky_seal/util/sets.dart';

class CardPreview {
  String code;
  String imgUrl;
  late Image image;

  CardPreview({required this.code, required this.imgUrl}) {
    image = Image.network(convertSetCodeToImageUrl(code));
  }

  preloadImage(BuildContext context) async {
    await precacheImage(image.image, context);
  }
}
