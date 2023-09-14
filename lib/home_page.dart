import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:concealed/deck_builder.dart';
import 'package:concealed/structs/Card.dart';
import 'package:concealed/structs/Deck.dart';
import 'package:concealed/view/deck-list-view/DeckPermissions.dart';
import 'package:concealed/view/deck-list-view/deck-preview-card.dart';
import 'package:concealed/view/deck-list-view/deck-preview-metadata.dart';
import 'package:concealed/view/state/app_state_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _future = supa.Supabase.instance.client
      .from('decks')
      .select<List<Map<String, dynamic>>>()
      .eq('owner', supa.Supabase.instance.client.auth.currentUser?.id);

  Future<void> _newDeckDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New deck'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeckBuilder(
                                  deckId: null,
                                  deckName: null,
                                  permissions: DeckPermissions(
                                      ownerOfDeck: supa.Supabase.instance.client
                                          .auth.currentUser!.id),
                                )));
                  },
                  child: Card(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('From scratch',
                              style: Theme.of(context).textTheme.headlineSmall),
                          Text('Start with no cards')
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState =
        Provider.of<AppStateProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final decks = snapshot.data!;
          return ListView.builder(
            itemCount: decks.length,
            itemBuilder: ((context, index) {
              final thisDeck = decks[index];

              return DeckPreviewCard(
                  permissions: DeckPermissions(ownerOfDeck: thisDeck['owner']),
                  deckPreviewMetadata: DeckPreviewMetadata(
                      id: thisDeck['id'],
                      name: thisDeck['name'] ?? 'My deck',
                      featuredCard: thisDeck['featured_card']));
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _newDeckDialogBuilder(context);
        },
        label: const Text('New deck'),
        icon: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
