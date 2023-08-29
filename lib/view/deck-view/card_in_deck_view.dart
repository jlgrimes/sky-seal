import 'package:flutter/material.dart';
import 'package:sky_seal/view/card-view/card_stack_view.dart';
import 'package:sky_seal/view/card-view/focused_card_container.dart';
import 'package:sky_seal/view/primatives/card_view.dart';

class CardInDeckview extends StatefulWidget {
  String code;
  bool isCollapsed = true;

  CardInDeckview(this.code, {super.key});

  @override
  _CardInDeckViewState createState() => _CardInDeckViewState();
}

class _CardInDeckViewState extends State<CardInDeckview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusedCardContainer(
        child: CardView(widget.code), menuContent: CardStackView(widget.code));
  }
}
