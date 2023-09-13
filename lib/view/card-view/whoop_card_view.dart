import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:concealed/view/primatives/card_view.dart';
import 'package:concealed/view/state/app_state_provider.dart';

class WhoopCardView extends CardView {
  WhoopCardView(code) : super(code);

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);

    return CardView(appState.currentlyViewingCard ?? code);
  }
}
