import 'package:flutter/material.dart';
import 'package:sky_seal/view/card-view/card_stack_view.dart';
import 'package:sky_seal/view/card-view/card_stack_view_overlay.dart';
import 'package:sky_seal/view/card-view/whoop_card_view.dart';
import 'package:sky_seal/view/primatives/card_view.dart';

class FocusedCardContainer extends StatefulWidget {
  final String code;
  final Function(String? code) setCurrentlyViewingCard;

  const FocusedCardContainer(
      {Key? key, required this.code, required this.setCurrentlyViewingCard});

  @override
  _FocusedMenuHolderState createState() => _FocusedMenuHolderState();
}

class _FocusedMenuHolderState extends State<FocusedCardContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Tween<double> scaleTween; // <<< Tween for first animation
  late Tween<Offset> translateTween; // <<< Tween for first animation
  late Animation<double> scaleAnimation; // <<< second animation
  late Animation<Offset> translateAnimation; // <<< second animation

  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  Size? childSize;

  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
  }

  getOffsetAndDeclareAnimations(BuildContext context) {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject()! as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });

    double scale = 2.2;

    scaleTween = Tween(begin: 1, end: scale);
    Size windowSize = MediaQuery.of(context).size;

    final double xTranslate = (windowSize.width / 2) - size.width / 2;
    final double yTranslate = (windowSize.height / 2) - size.height / 2;

    Offset startingOffset = Offset(offset.dx, offset.dy);
    Offset finalOffset = Offset(xTranslate, yTranslate);
    translateTween = Tween(begin: startingOffset, end: finalOffset);

    translateAnimation = controller
        .drive(translateTween.chain(CurveTween(curve: Curves.easeOutBack)));
    scaleAnimation = controller
        .drive(scaleTween.chain(CurveTween(curve: Curves.easeOutBack)));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          getOffsetAndDeclareAnimations(context);
          await Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 2000),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    animation = Tween(begin: 1.0, end: 1.0).animate(animation);
                    controller.forward();
                    return FadeTransition(
                        opacity: animation,
                        child: CardStackViewOverlay(
                          menuContent: CardStackView(
                              widget.code, widget.setCurrentlyViewingCard),
                          child: WhoopCardView(widget.code),
                          childOffset: childOffset,
                          childSize: childSize!,
                          controller: controller,
                          scaleAnimation: scaleAnimation,
                          translateAnimation: translateAnimation,
                          setCurrentlyViewingCard:
                              widget.setCurrentlyViewingCard,
                        ));
                  },
                  fullscreenDialog: true,
                  opaque: false));
        },
        child: CardView(widget.code));
  }
}
