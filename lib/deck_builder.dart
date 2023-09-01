import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:sky_seal/structs/Deck.dart';
import 'package:sky_seal/view/add-card-view/add_card_scaffold.dart';
import 'package:sky_seal/view/deck-view/deck_view.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeckBuilder extends StatefulWidget {
  @override
  State<DeckBuilder> createState() => _DeckBuilderState();
}

class _DeckBuilderState extends State<DeckBuilder> {
  saveDeck(Deck currentDeck) async {
    final List<Map<String, dynamic>> data = await Supabase.instance.client
        .from('decks')
        .insert({'name': 'My deck'}).select();
    final deckId = data[0]['id'];
    await Supabase.instance.client.from('cards').insert(currentDeck.cards
        .map((e) => ({'code': e.code, 'count': e.count, 'deck_id': deckId}))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState =
        provider.Provider.of<AppStateProvider>(context, listen: false);

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
                  await saveDeck(appState.deck);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Deck saved')));
                },
                icon: const Icon(Icons.save_outlined))
          ],
        )),
      ),
    );
  }
}
