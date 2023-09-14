import 'dart:convert';

import 'package:concealed/deck_builder.dart';
import 'package:flutter/material.dart';
import 'package:concealed/structs/Card.dart';
import 'package:concealed/structs/Deck.dart';
import 'package:concealed/view/deck-list-view/DeckPermissions.dart';
import 'package:concealed/view/state/card_positioning_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

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
  DeckPermissions? permissions;

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

  loadDeck(List<Map<String, dynamic>> cards, String deckId, String? deckName,
      DeckPermissions? deckPermissions, BuildContext context) async {
    // Should be a more generic check but whatcha gonna do

    deck.id = deckId;
    if (deckName != null) deck.name = deckName;

    if (deckPermissions != null) {
      deck.permissions = deckPermissions;
    } else if (deck.permissions == null) {
      final deckMetadata = await Supabase.instance.client
          .from('decks')
          .select<List<Map<String, dynamic>>>('owner')
          .eq('id', deckId);
      deck.permissions = DeckPermissions(ownerOfDeck: deckMetadata[0]['owner']);
    }

    final cardList = cards
        .map((e) => PokemonCard(
            id: e['id'],
            code: e['code'],
            count: e['count'],
            supertype: e['supertype'],
            rarity: e['rarity']))
        .toList();
    deck.cards = cardList;

    for (var card in deck.cards) {
      await card.preloadImage(context);
    }

    hasUnsavedChanges = false;
    notifyListeners();

    return deck;
  }

  loadDeckFromList(String list) async {
    final listLength = utf8.encode(list).length.toString();

    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('https://www.concealed.cards/api/list'));
    request.body = list;
    // request.body =
    //     '''Pokémon: 9\r\n2 Frigibax PAL 57\r\n3 Chien-Pao ex PAL 61\r\n1 Lumineon V BRS 40\r\n1 Frigibax PAL 58\r\n2 Pidgeot ex OBF 164\r\n2 Pidgey OBF 162\r\n3 Baxcalibur PAL 60\r\n1 Radiant Greninja ASR 46\r\n1 Manaphy BRS 41\r\n\r\nTrainer: 15\r\n1 Hisuian Heavy Ball ASR 146\r\n3 Ultra Ball ROS 93\r\n3 Skaters\' Park FST 242\r\n2 Nest Ball SUM 123\r\n1 Escape Rope PRC 127\r\n1 Energy Retrieval SVI 171\r\n4 Irida ASR 147\r\n4 Superior Energy Retrieval PLF 103\r\n4 Battle VIP Pass FST 225\r\n3 Boss\'s Orders PAL 172\r\n1 Iono PAL 185\r\n1 Cynthia\'s Ambition BRS 138\r\n1 Lost Vacuum LOR 162\r\n1 Canceling Cologne ASR 136\r\n4 Rare Candy SVI 191\r\n\r\nEnergy: 1\r\n10 Basic {W} Energy SVE 3\r\n\r\nTotal Cards: 60''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final String res = await response.stream.bytesToString();
      final Map<String, dynamic> json = jsonDecode(res);
      final List<dynamic> cards = json['cards'];

      final cardList = cards
          .map((e) => PokemonCard(
              code: e['code'],
              count: e['count'],
              supertype: null,
              rarity: null))
          .toList();

      deck.cards = cardList;

      hasUnsavedChanges = false;
      notifyListeners();
    } else {
      debugPrint(response.reasonPhrase);
    }

    return deck;
  }

  loadNewDeck() {
    deck = Deck(
        name: 'New deck',
        cards: [],
        permissions: DeckPermissions(
            ownerOfDeck: Supabase.instance.client.auth.currentUser!.id));
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

      if (a.rarity == null) return 1;
      if (b.rarity == null) return 1;

      if (rarityOrder.indexOf(a.rarity!) < rarityOrder.indexOf(b.rarity!)) {
        return 1;
      }
      if (rarityOrder.indexOf(a.rarity!) > rarityOrder.indexOf(b.rarity!)) {
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

      await loadDeck([...insertedCards, ...upsertedCards], deckId!, deckName,
          null, context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deck saved')));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
