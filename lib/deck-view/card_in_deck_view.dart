import 'package:flutter/material.dart';
import 'package:sky_seal/primatives/card_view.dart';

class CardInDeckView extends CardView {
  void Function() openContainerAction;

  CardInDeckView(Function() this.openContainerAction);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.openContainerAction,
      child: CardView(),
    );
  }
}
