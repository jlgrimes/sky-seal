import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:share_plus/share_plus.dart';
import 'package:sky_seal/structs/Deck.dart';
import 'package:sky_seal/view/add-card-view/add_card_scaffold.dart';
import 'package:sky_seal/view/deck-list-view/deck-preview-metadata.dart';
import 'package:sky_seal/view/deck-list-view/share-deck/share-deck-button.dart';
import 'package:sky_seal/view/deck-view/deck_view.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeckBuilder extends StatefulWidget {
  String? deckId;

  DeckBuilder({required this.deckId});

  @override
  State<DeckBuilder> createState() => _DeckBuilderState();
}

class _DeckBuilderState extends State<DeckBuilder> {
  late AsyncMemoizer _memoizer;
  bool _pageHasLoaded = false;

  @override
  void initState() {
    super.initState();
    _memoizer = AsyncMemoizer();
  }

  Future _deckLoad(AppStateProvider appState) async {
    return _memoizer.runOnce(() async {
      final List<Map<String, dynamic>> cards = widget.deckId == null
          ? []
          : await Supabase.instance.client
              .from('cards')
              .select<List<Map<String, dynamic>>>()
              .eq('deck_id', widget.deckId);

      if (mounted) {
        final deck = await appState.loadDeck(cards, widget.deckId, context);

        setState(() {
          _pageHasLoaded = true;
        });

        return deck;
      } else {
        return Deck(cards: []);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = provider.Provider.of<AppStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Deck builder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
                future: _deckLoad(appState),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return DeckView();
                })
          ],
        ),
      ),
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          Visibility(
            visible: _pageHasLoaded,
            child: Container(
                margin: const EdgeInsets.only(bottom: 20.0, top: 10.0),
                child: FloatingActionButton.extended(
                  heroTag: 'add-card',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCardScaffold(
                                  addCardCallback: appState.addCardToDeck,
                                )));
                  },
                  icon: const Icon(Icons.add),
                  label: Text('Add Card'),
                  isExtended: false,
                )),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 12.0, top: 10.0),
            child: FloatingActionButton.extended(
              foregroundColor: appState.hasUnsavedChanges
                  ? Theme.of(context).colorScheme.onTertiaryContainer
                  : Theme.of(context).colorScheme.onSecondaryContainer,
              backgroundColor: appState.hasUnsavedChanges
                  ? Theme.of(context).colorScheme.tertiaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
              heroTag: 'save-deck',
              isExtended: appState.hasUnsavedChanges,
              elevation: appState.hasUnsavedChanges ? 6 : 1,
              onPressed: () async {
                appState.saveChanges(context);
              },
              label: const Text('Save changes'),
              icon: const Icon(Icons.save_outlined),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: BottomAppBar(
            child: Row(
          children: [
            ShareDeckButton(),
          ],
        )),
      ),
    );
  }
}
