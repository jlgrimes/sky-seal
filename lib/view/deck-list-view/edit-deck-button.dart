import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sky_seal/view/state/app_state_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

class EditDeckButton extends StatelessWidget {
  final _deckNameTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = Provider.of<AppStateProvider>(context);

    return IconButton(
        onPressed: () {
          _dialogBuilder(context, appState.deck.id, appState.updateDeckName);
          // Share.share(
          //     'https://skyseal.app/${appState.deck.id.toString()}');
        },
        icon: const Icon(Icons.edit_outlined));
  }

  Future<void> _dialogBuilder(BuildContext context, String? deckId,
      Function(String newName) updateDeckName) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit deck'),
          content: TextField(
            controller: _deckNameTextFieldController,
            decoration: const InputDecoration(hintText: 'Deck name'),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Save'),
              onPressed: () async {
                await supa.Supabase.instance.client
                    .from('decks')
                    .update({'name': _deckNameTextFieldController.text}).eq(
                        'id', deckId);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
