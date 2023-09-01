import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_seal/util/deck.dart';
import 'package:sky_seal/view/card-view/constants.dart';
import 'package:sky_seal/view/primatives/card_view.dart';
import 'package:sky_seal/view/primatives/constants.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';

class CardStackView extends StatefulWidget {
  late int startingPos;

  CardStackView(this.startingPos, {super.key});

  @override
  State<CardStackView> createState() => _CardStackViewState();
}

class _CardStackViewState extends State<CardStackView> {
  late int _codeIdx;
  final SwiperController _swiperController = SwiperController();

  void initState() {
    super.initState();
    _codeIdx = widget.startingPos;
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);

    return Container(
      child: Column(children: [
        (Expanded(
            child: Column(
          children: [
            Flexible(
                child: Stack(
              alignment: Alignment.center,
              children: [
                Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: desiredFinalWidth,
                            child: CardView(appState.deck.cards[index].code),
                          )
                        ]);
                  },
                  itemCount: appState.deck.cards.length,
                  index: _codeIdx,
                  onIndexChanged: ((value) {
                    appState.sneakilySetCurrentlyViewingCard(
                        appState.deck.cards[value].code);
                    setState(() {
                      _codeIdx = value;
                    });
                  }),
                  controller: _swiperController,
                  loop: false,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filledTonal(
                      onPressed: _codeIdx == 0
                          ? null
                          : () => _swiperController.previous(),
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    IconButton.filledTonal(
                        onPressed: _codeIdx == appState.deck.cards.length - 1
                            ? null
                            : () => _swiperController.next(),
                        icon: const Icon(Icons.chevron_right_rounded))
                  ],
                )
              ],
            ))
          ],
        )))
      ]),
    );
  }
}
