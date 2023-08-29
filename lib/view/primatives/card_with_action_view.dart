import 'package:flutter/material.dart';
import 'package:sky_seal/view/primatives/card_view.dart';

class CardWithActionView extends StatelessWidget {
  void Function() openContainerAction;
  String code;

  CardWithActionView(Function() this.openContainerAction, this.code);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.openContainerAction,
      child: CardView(code),
    );
  }
}
