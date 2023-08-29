import 'package:flutter/material.dart';
import 'package:sky_seal/view/card-view/card_stack_view_overlay.dart';

class FocusedCardContainer extends StatefulWidget {
  final Widget child, menuContent;

  const FocusedCardContainer(
      {Key? key, required this.child, required this.menuContent});

  @override
  _FocusedMenuHolderState createState() => _FocusedMenuHolderState();
}

class _FocusedMenuHolderState extends State<FocusedCardContainer> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  Size? childSize;

  getOffset() {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject()! as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          getOffset();
          await Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 100),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    animation = Tween(begin: 0.0, end: 1.0).animate(animation);
                    return FadeTransition(
                        opacity: animation,
                        child: CardStackViewOverlay(
                          menuContent: widget.menuContent,
                          child: widget.child,
                          childOffset: childOffset,
                          childSize: childSize!,
                        ));
                  },
                  fullscreenDialog: true,
                  opaque: false));
        },
        child: widget.child);
  }
}
