import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:sky_seal/view/card-view/card_stack_view.dart';
import 'package:sky_seal/view/card-view/focused_card_container.dart';
import 'package:sky_seal/view/primatives/card_view.dart';
import 'package:sky_seal/view/primatives/constants.dart';

class CardInDeckview extends StatefulWidget {
  String code;
  bool isCollapsed = true;

  CardInDeckview(this.code, {super.key});

  @override
  _CardInDeckViewState createState() => _CardInDeckViewState();
}

class _CardInDeckViewState extends State<CardInDeckview> {
  late String code;

  @override
  void initState() {
    super.initState();
    code = widget.code;
  }

  @override
  Widget build(BuildContext context) {
    return FocusedCardContainer(
        child: CardView(code), menuContent: CardStackView());
  }
}
