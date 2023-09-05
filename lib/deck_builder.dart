import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:share_plus/share_plus.dart';
import 'package:sky_seal/structs/Deck.dart';
import 'package:sky_seal/view/add-card-view/add_card_scaffold.dart';
import 'package:sky_seal/view/deck-list-view/share-deck/share-deck-button.dart';
import 'package:sky_seal/view/deck-view/deck_view.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeckBuilder extends StatefulWidget {
  @override
  State<DeckBuilder> createState() => _DeckBuilderState();
}

class _DeckBuilderState extends State<DeckBuilder> {
  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = provider.Provider.of<AppStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Deck builder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[DeckView()],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddCardScaffold(
                        addCardCallback: appState.addCardToDeck,
                      )));
        },
        label: const Text('Add card'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: BottomAppBar(
            child: Row(
          children: [
            IconButton(
                onPressed: () async {
                  try {
                    String? userId =
                        Supabase.instance.client.auth.currentUser?.id;
                    if (userId == null)
                      throw 'User is not logged in and cannot save decks';

                    String? deckId = appState.deck.id;
                    if (deckId == null) {
                      final List<Map<String, dynamic>> data =
                          await Supabase.instance.client.from('decks').insert(
                              {'name': 'My deck', 'owner': userId}).select();
                      deckId = data[0]['id'];
                    }

                    List<Map<String, dynamic>> cardsToBeInserted = [];
                    List<Map<String, dynamic>> cardsToBeUpserted = [];

                    appState.deck.cards.forEach((element) {
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
                    appState.loadDeck(
                        [...insertedCards, ...upsertedCards], deckId!);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Deck saved')));
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                icon: const Icon(Icons.save_outlined)),
            ShareDeckButton(),
          ],
        )),
      ),
    );
  }
}
