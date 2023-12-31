import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:concealed/structs/Card.dart';
import 'package:concealed/view/card-view/card_animator.dart';
import 'package:concealed/view/card-view/card_stack_view_overlay.dart';
import 'package:concealed/view/card-view/card_view_with_count.dart';
import 'package:concealed/view/card-view/whoop_card_view.dart';
import 'package:concealed/view/primatives/card_view.dart';
import 'package:concealed/view/state/app_state_provider.dart';

class FocusedCardContainer extends StatefulWidget {
  final PokemonCard card;

  const FocusedCardContainer({Key? key, required this.card});

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

    cardAnimator.computeAnimationDetails(
      context,
      renderBox,
      size,
      offset,
    );

    AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);

    appState.cardPositionState.addCardPosition(widget.card.code, offset);
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
          appState.setCurrentlyViewingCard(widget.card.code);

          Future.delayed(const Duration(milliseconds: 300), () {
            //asynchronous delay
            if (mounted) {
              appState.setDeckViewState(DeckViewState.focusedOnCard);
            }
          });

          cardAnimator.runEnterAnimation();
          await Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 2000),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    animation = Tween(begin: 1.0, end: 1.0).animate(animation);
                    return FadeTransition(
                        opacity: animation,
                        child: CardStackViewOverlay(
                          card: widget.card,
                          childOffset: childOffset,
                          childSize: childSize!,
                          cardAnimator: cardAnimator,
                          child: WhoopCardView(widget.card.code),
                        ));
                  },
                  fullscreenDialog: true,
                  opaque: false));
        },
        child: CardViewWithCount(pokemonCard: widget.card));
  }
}
