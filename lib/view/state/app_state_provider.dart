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

  addCardToDeck(PokemonCard card) {
    deck.addCard(card);
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
    hasUnsavedChanges = true;
    notifyListeners();
  }

  updateDeckName(String newName) {
    deck.name = newName;
  }

  loadDeck(List<Map<String, dynamic>> cards, String? deckId, String? deckName,
      BuildContext context) async {
    final cardList = cards
        .map((e) => PokemonCard(
            id: e['id'],
            code: e['code'],
            count: e['count'],
            supertype: e['supertype'],
            rarity: e['rarity']))
        .toList();
    deck = Deck(cards: cardList, id: deckId, name: deckName);

    for (var card in deck.cards) {
      await card.preloadImage(context);
    }

    if (deckId != null) {
      hasUnsavedChanges = false;
      notifyListeners();
    }

    return deck;
  }

  getFeaturedCard() {
    final List<String> rarityOrder = [
      "Common",
      "Uncommon"
          "Rare",
      "Rare Holo",
      "Radiant Rare",
      "Rare Prism Star",
      "Rare ACE",
      "Rare BREAK",
      "Amazing Rare",
      "Classic Collection",
      "Promo",
      "LEGEND",
      "Rare Shining",
      "Rare Shiny",
      "Rare Shiny GX",
      "Rare Ultra",
      "Ultra Rare",
      "Rare Holo EX",
      "Rare Holo GX",
      "Rare Holo LV.X",
      "Rare Holo Star",
      "Rare Holo V",
      "Rare Holo VMAX",
      "Rare Holo VSTAR",
      "Rare Prime",
      "Trainer Gallery Rare Holo",
      "Hyper Rare",
      "Double Rare",
      "Illustration Rare",
      "Special Illustration Rare",
      "Rare Rainbow",
      "Rare Secret",
    ];

    List<PokemonCard> sortedByFeaturedCards = deck.cards;
    sortedByFeaturedCards.sort(((a, b) {
      if (a.supertype != 'Pokémon') return 1;
      if (b.supertype != 'Pokémon') return -1;

      if (rarityOrder.indexOf(a.rarity) < rarityOrder.indexOf(b.rarity)) {
        return 1;
      }
      if (rarityOrder.indexOf(a.rarity) > rarityOrder.indexOf(b.rarity)) {
        return -1;
      }

      final aSetNum = int.parse(a.code.split('-')[1]);
      final bSetNum = int.parse(b.code.split('-')[1]);
      if (aSetNum < bSetNum) return 1;
      if (aSetNum > bSetNum) return -1;

      return 0;
    }));

    return sortedByFeaturedCards[0].code;
  }

  saveChanges(BuildContext context) async {
    try {
      String? userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw 'User is not logged in and cannot save decks';

      String? deckId = deck.id;
      String? deckName = deck.name;
      final featuredCard = getFeaturedCard();

      if (deckId == null) {
        final List<Map<String, dynamic>> data = await Supabase.instance.client
            .from('decks')
            .insert({
          'name': deckName,
          'owner': userId,
          'featured_card': featuredCard
        }).select();
        deckId = data[0]['id'];
      } else {
        await Supabase.instance.client
            .from('decks')
            .update({'featured_card': featuredCard}).eq('id', deckId);
      }

      List<Map<String, dynamic>> cardsToBeInserted = [];
      List<Map<String, dynamic>> cardsToBeUpserted = [];

      deck.cards.forEach((element) {
        if (element.id == null) {
          cardsToBeInserted.add({
            'code': element.code,
            'count': element.count,
            'deck_id': deckId,
            'rarity': element.rarity,
            'supertype': element.supertype
          });
        } else {
          cardsToBeUpserted.add({
            'id': element.id,
            'code': element.code,
            'count': element.count,
            'deck_id': deckId,
            'rarity': element.rarity,
            'supertype': element.supertype
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

      await loadDeck(
          [...insertedCards, ...upsertedCards], deckId!, deckName, context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deck saved')));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
