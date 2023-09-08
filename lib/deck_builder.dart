import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:share_plus/share_plus.dart';
import 'package:sky_seal/structs/Deck.dart';
import 'package:sky_seal/view/add-card-view/add_card_scaffold.dart';
import 'package:sky_seal/view/deck-list-view/DeckPermissions.dart';
import 'package:sky_seal/view/deck-list-view/deck-preview-metadata.dart';
import 'package:sky_seal/view/deck-list-view/edit-deck-button.dart';
import 'package:sky_seal/view/deck-list-view/share-deck-button.dart';
import 'package:sky_seal/view/deck-view/deck_view.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeckBuilder extends StatefulWidget {
  String? deckId;
  String? deckName;
  DeckPermissions? permissions;

  DeckBuilder(
      {required this.deckId,
      required this.deckName,
      required this.permissions});

  @override
  State<DeckBuilder> createState() => _DeckBuilderState();
}

class _DeckBuilderState extends State<DeckBuilder> {
  late AsyncMemoizer _memoizer;
  bool _pageHasLoaded = false;
  bool _userCanEdit = false;

  @override
  void initState() {
    super.initState();
    _memoizer = AsyncMemoizer();
  }

  Future _deckLoad(AppStateProvider appState) async {
    return _memoizer.runOnce(() async {
      Deck deck = Deck(cards: []);

      if (mounted) {
        if (widget.deckId != null) {
          final List<Map<String, dynamic>> cards = await Supabase
              .instance.client
              .from('cards')
              .select<List<Map<String, dynamic>>>()
              .eq('deck_id', widget.deckId);

          deck = await appState.loadDeck(cards, widget.deckId!, widget.deckName,
              widget.permissions, context);
        }

        setState(() {
          _pageHasLoaded = true;
        });

        if (widget.permissions != null) {
          setState(() {
            _userCanEdit = widget.permissions!.canEdit();
          });
        }
      }

      return deck;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = provider.Provider.of<AppStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(appState.deck.name ?? 'Deck'),
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
            visible: _pageHasLoaded && _userCanEdit,
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
          Visibility(
              visible: _userCanEdit,
              child: Container(
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
              ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: BottomAppBar(
            child: Row(
          children: [
            Visibility(visible: _userCanEdit, child: EditDeckButton()),
            ShareDeckButton(),
          ],
        )),
      ),
    );
  }
}
