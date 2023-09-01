import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_seal/deck_builder.dart';
import 'package:sky_seal/structs/Card.dart';
import 'package:sky_seal/structs/Deck.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';
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
              final thisDeckId = thisDeck['id'];

              return ListTile(
                title: Text(thisDeck['name']),
                onTap: () async {
                  final cards = await supa.Supabase.instance.client
                      .from('cards')
                      .select<List<Map<String, dynamic>>>()
                      .eq('deck_id', thisDeckId);

                  appState.loadDeck(cards, thisDeckId);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DeckBuilder()));
                },
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DeckBuilder()));
        },
        label: const Text('New deck'),
        icon: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
