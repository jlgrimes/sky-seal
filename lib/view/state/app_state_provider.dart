import 'package:flutter/material.dart';
import 'package:sky_seal/structs/Card.dart';
import 'package:sky_seal/structs/Deck.dart';
import 'package:sky_seal/view/state/card_positioning_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum DeckViewState {
  noCardsFocused,
  enteringCardFocus,
  focusedOnCard,
  exitingCardFocus
}

class AppStateProvider extends ChangeNotifier {
  String? currentlyViewingCard;
  DeckViewState deckViewState = DeckViewState.noCardsFocused;
  CardPositioningState cardPositionState = CardPositioningState();
  Deck deck = Deck(cards: []);
  bool hasUnsavedChanges = false;

  sneakilySetCurrentlyViewingCard(String? code) {
    currentlyViewingCard = code;
  }

  setCurrentlyViewingCard(String? code) {
    currentlyViewingCard = code;
    notifyListeners();
  }

  setDeckViewState(DeckViewState newState) {
    debugPrint(newState.toString());
    deckViewState = newState;
    notifyListeners();
  }

  addCardToDeck(String code) {
    deck.addCard(code);
    hasUnsavedChanges = true;
    notifyListeners();
  }

  removeCardFromDeck(String code) {
    deck.removeCard(code);
    hasUnsavedChanges = true;
    notifyListeners();
  }

  updateCardCount(int cardIdx, int newCount) {
    deck.cards[cardIdx].count = newCount;
    notifyListeners();
  }

  loadDeck(List<Map<String, dynamic>> cards, String? deckId,
      BuildContext context) async {
    final cardList = cards
        .map(
            (e) => PokemonCard(id: e['id'], code: e['code'], count: e['count']))
        .toList();
    deck = Deck(cards: cardList, id: deckId);

    for (var card in deck.cards) {
      await card.preloadImage(context);
    }

    if (deckId != null) {
      notifyListeners();
    }

    return deck;
  }

  saveChanges(BuildContext context) async {
    try {
      String? userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw 'User is not logged in and cannot save decks';

      String? deckId = deck.id;
      if (deckId == null) {
        final List<Map<String, dynamic>> data = await Supabase.instance.client
            .from('decks')
            .insert({'name': 'My deck', 'owner': userId}).select();
        deckId = data[0]['id'];
      }

      List<Map<String, dynamic>> cardsToBeInserted = [];
      List<Map<String, dynamic>> cardsToBeUpserted = [];

      deck.cards.forEach((element) {
        if (element.id == null) {
          cardsToBeInserted.add({
            'code': element.code,
            'count': element.count,
            'deck_id': deckId
          });
        } else {
          cardsToBeUpserted.add({
            'id': element.id,
            'code': element.code,
            'count': element.count,
            'deck_id': deckId
          });
        }
      });

      final insertedCards = await Supabase.instance.client
          .from('cards')
          .insert(cardsToBeInserted)
          .select<List<Map<String, dynamic>>>();

      final upsertedCards = await Supabase.instance.client
          .from('cards')
          .upsert(cardsToBeUpserted)
          .select<List<Map<String, dynamic>>>();
      await loadDeck([...insertedCards, ...upsertedCards], deckId!, context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deck saved')));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
