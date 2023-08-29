import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:sky_seal/view/card-view/card_stack_view.dart';
import 'package:sky_seal/view/primatives/card_with_action_view.dart';

class CardInDeckview extends StatefulWidget {
  String code;
  bool isCollapsed = true;

  CardInDeckview(this.code, {super.key});

  @override
  _CardInDeckViewState createState() => _CardInDeckViewState();

  //   return OpenContainer(
  //     closedBuilder: (context, action) {
  //       return CardWithActionView(action, code);
  //     },
  //     openBuilder: (context, action) {
  //       return CardStackView(action);
  //     },
  //     transitionType: ContainerTransitionType.fadeThrough,
  //   );
  // }
}

class _CardInDeckViewState extends State<CardInDeckview> {
  late String code;
  bool _isCollapsed = true;
  double aspectRatio = 508 / 710;

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
    return AnimatedContainer(
      width: _isCollapsed ? 160 * aspectRatio : 380 * aspectRatio,
      height: _isCollapsed ? 160 : 380,
      duration: Duration(milliseconds: 500),
      curve: _isCollapsed ? Curves.easeOutCubic : Curves.easeOutBack,
      child: _isCollapsed
          ? CardWithActionView(_toggleIsCollapsed, code)
          : CardStackView(_toggleIsCollapsed),
    );
  }
}
