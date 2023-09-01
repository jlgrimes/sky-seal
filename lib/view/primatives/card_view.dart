import 'package:flutter/material.dart';
import 'package:sky_seal/structs/Card.dart';
import 'package:sky_seal/util/sets.dart';
import 'package:sky_seal/view/primatives/constants.dart';

class CardView extends StatelessWidget {
  String code;
  String imageUrl;

  CardView(this.code) : imageUrl = convertSetCodeToImageUrl(code);

  @override
  Widget build(BuildContext context) {
    return Image.network(imageUrl);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.network(
        imageUrl,
        width: 400 * cardAspectRatio,
      )
    ]);
    return Container(
      width: 400.0 * cardAspectRatio,
      child: Image.network(imageUrl),
    );
  }
}
