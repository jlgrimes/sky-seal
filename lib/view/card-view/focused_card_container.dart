import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_seal/view/card-view/card_animator.dart';
import 'package:sky_seal/view/card-view/card_stack_view.dart';
import 'package:sky_seal/view/card-view/card_stack_view_overlay.dart';
import 'package:sky_seal/view/card-view/whoop_card_view.dart';
import 'package:sky_seal/view/primatives/card_view.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';

class FocusedCardContainer extends StatefulWidget {
  final String code;

  const FocusedCardContainer({Key? key, required this.code});

  @override
  _FocusedMenuHolderState createState() => _FocusedMenuHolderState();
}

class _FocusedMenuHolderState extends State<FocusedCardContainer>
    with TickerProviderStateMixin, AfterLayoutMixin<FocusedCardContainer> {
  late CardAnimator cardAnimator;

  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  Size? childSize;

  void initState() {
    super.initState();

    cardAnimator = CardAnimator(
        tickerProvider: this, animationType: CardAnimationType.enter);
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

    cardAnimator.computeAnimationDetails(context, renderBox, size, offset);

    AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);

    appState.cardPositionState.addCardPosition(widget.code, offset);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getOffsetAndDeclareAnimations(context);
  }

  @override
  void dispose() {
    super.dispose();
    cardAnimator.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);

    return GestureDetector(
        key: containerKey,
        onTap: () async {
          getOffsetAndDeclareAnimations(context);
          appState.setDeckViewState(DeckViewState.enteringCardFocus);
          appState.setCurrentlyViewingCard(widget.code);

          Future.delayed(const Duration(milliseconds: 400), () {
            //asynchronous delay
            if (mounted) {
              appState.setDeckViewState(DeckViewState.focusedOnCard);
            }
          });

          await Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 2000),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    animation = Tween(begin: 1.0, end: 1.0).animate(animation);
                    cardAnimator.runEnterAnimation();
                    return FadeTransition(
                        opacity: animation,
                        child: CardStackViewOverlay(
                          code: widget.code,
                          menuContent: CardStackView(widget.code),
                          childOffset: childOffset,
                          childSize: childSize!,
                          cardAnimator: cardAnimator,
                          child: WhoopCardView(widget.code),
                        ));
                  },
                  fullscreenDialog: true,
                  opaque: false));
        },
        child: CardView(widget.code));
  }
}
