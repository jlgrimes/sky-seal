import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:sky_seal/view/card-view/card_stack_view.dart';
import 'package:sky_seal/view/card-view/focused_card_container.dart';
import 'package:sky_seal/view/primatives/card_with_action_view.dart';
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
  bool _isCollapsed = true;

  @override
  void initState() {
    super.initState();
    code = widget.code;
  }

  void _toggleIsCollapsed() {
    setState(() {
      if (_isCollapsed) {
        _isCollapsed = false;
      } else {
        _isCollapsed = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusedCardContainer(
        child: CardWithActionView(_toggleIsCollapsed, code),
        menuContent: CardStackView(_toggleIsCollapsed));

    return Indexed(
        index: _isCollapsed ? 0 : 1,
        child: Stack(children: [
          Container(),
          Positioned(
              child: AnimatedContainer(
            width: _isCollapsed
                ? 160 * cardAspectRatio
                : MediaQuery.of(context).size.width,
            height: _isCollapsed ? 160 : 450,
            duration: Duration(milliseconds: 500),
            curve: _isCollapsed ? Curves.easeOutCubic : Curves.easeOutBack,
            child: _isCollapsed
                ? CardWithActionView(_toggleIsCollapsed, code)
                : CardStackView(_toggleIsCollapsed),
          ))
        ]));
  }
}
