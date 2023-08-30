import 'package:flutter/material.dart';

class DeckViewStoreProvider extends InheritedWidget {
  final String? currentlyViewingCard;

  DeckViewStoreProvider({
    required Widget child,
    required this.currentlyViewingCard,
  }) : super(child: child);

  @override
  bool updateShouldNotify(DeckViewStoreProvider oldWidget) =>
      currentlyViewingCard != oldWidget.currentlyViewingCard;

  static DeckViewStoreProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DeckViewStoreProvider>()!;
}
